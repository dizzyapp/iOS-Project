//
//  CommentTextFieldView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentTextFieldViewDelegate: class {
    func commentTextFieldViewSendPressed(_ view: UIView, with message: String)
}

final class CommentTextFieldView: UIView {
    
    private let profileImageView: UIImageView = UIImageView()
    let textField = CommentsTextField()
    var text: String {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    private let profileImageSize = CGSize(width: 37.5, height: 37.5)
    weak var delegate: CommentTextFieldViewDelegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserImage(fromUrl imageUrl: URL) {
        profileImageView.kf.setImage(with: imageUrl, placeholder: Images.profilePlaceholderIcon())
    }
    
    private func addSubviews() {
        addSubviews([profileImageView, textField])
    }
    
    private func layoutViews() {
        layoutProfileImageView()
        layoutTextField()
    }
    
    private func layoutProfileImageView() {
        profileImageView.snp.makeConstraints { (profileImageView) in
            profileImageView.leading.equalToSuperview().offset(Metrics.doublePadding)
            profileImageView.top.equalToSuperview()
            profileImageView.bottom.equalToSuperview()
            profileImageView.height.equalTo(profileImageSize.height)
            profileImageView.width.equalTo(profileImageSize.width)
        }
        
        profileImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func layoutTextField() {
        textField.snp.makeConstraints { (textField) in
            textField.centerY.equalTo(profileImageView.snp.centerY)
            textField.height.equalTo(profileImageView.snp.height)
            textField.leading.equalTo(profileImageView.snp.trailing).offset(Metrics.padding)
            textField.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func setupViews() {
        setupProfileImageView()
        setupTextField()    
        addGestures()
    }
    
    private func setupProfileImageView() {
        self.profileImageView.contentMode = .scaleToFill
        self.profileImageView.image = Images.profilePlaceholderIcon()
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = profileImageSize.height / 2
    }
    
    private func setupTextField() {
        textField.setBorder(borderColor: UIColor.white.withAlphaComponent(0.5), cornerRadius: 18)
        textField.layer.borderWidth = 1
        textField.delegate = self
    }
    
    private func addGestures() {
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onDownSwipe))
        downSwipeGesture.direction = .down
        self.addGestureRecognizer(downSwipeGesture)
    }
    
    @objc private func onDownSwipe() {
        endEditing(true)
    }
}

extension CommentTextFieldView: CommentsTextFieldDelegate {
    func sendPressed() {
        delegate?.commentTextFieldViewSendPressed(self, with: textField.text)
    }
}
