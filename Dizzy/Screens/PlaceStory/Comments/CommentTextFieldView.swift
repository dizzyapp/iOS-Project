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
    
    weak var delegate: CommentTextFieldViewDelegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            profileImageView.bottom.top.equalToSuperview()
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
    }
    
    private func setupProfileImageView() {
        self.profileImageView.contentMode = .center
        self.profileImageView.kf.setImage(with: URL(fileURLWithPath: ""), placeholder: Images.profilePlaceholderIcon())
    }
    
    private func setupTextField() {
        textField.setBorder(borderColor: UIColor(hexString: "A7B0FF"), cornerRadius: 20)
        textField.delegate = self
    }
}

extension CommentTextFieldView: CommentsTextFieldDelegate {
    func sendPressed() {
        delegate?.commentTextFieldViewSendPressed(self, with: textField.text)
    }
}
