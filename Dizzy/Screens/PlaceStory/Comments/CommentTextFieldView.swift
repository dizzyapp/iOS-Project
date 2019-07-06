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
    let textField = UITextField().withTransperentRoundedCorners(borderColor: UIColor(hexString: "A7B0FF"), cornerRadius: 20)
    private let sendButton = UIButton(type: .system)
    
    weak var delegate: CommentTextFieldViewDelegate?
    var commentsTextFieldInputView = CommentsTextFieldInputView()
    let sendButtonSize = CGSize(width: 60, height: 30)
    
    init() {
        super.init(frame: .zero)
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
        layoutSendButton()
    }
    
    private func layoutProfileImageView() {
        profileImageView.snp.makeConstraints { (profileImageView) in
            profileImageView.leading.equalToSuperview().offset(Metrics.doublePadding)
            profileImageView.bottom.equalToSuperview()
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
    
    private func layoutSendButton() {
        sendButton.snp.makeConstraints { (sendButton) in
            sendButton.width.equalTo(sendButtonSize.width)
            sendButton.height.equalTo(sendButtonSize.height)
        }
    }
    
    private func setupViews() {
        setupProfileImageView()
        setupTextField()
        setupSendButton()
    }
    
    private func setupProfileImageView() {
        self.profileImageView.contentMode = .center
        self.profileImageView.kf.setImage(with: URL(fileURLWithPath: ""), placeholder: Images.profilePlaceholderIcon())
    }
    
    private func setupTextField() {
        textField.rightView = sendButton
        textField.rightViewMode = .always
        textField.font = Fonts.h8()
        textField.attributedPlaceholder = NSAttributedString(string: "Comment...".localized,
                                                             attributes: [.foregroundColor: UIColor.white])
        textField.inputAccessoryView = commentsTextFieldInputView
    }
    
    private func setupSendButton() {
        sendButton.titleLabel?.font = Fonts.h10()
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitle("Send".localized, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    @objc private func sendButtonPressed() {
        if let massage = textField.text {
            delegate?.commentTextFieldViewSendPressed(self, with: massage)
            textField.text = ""
        }
    }
}
