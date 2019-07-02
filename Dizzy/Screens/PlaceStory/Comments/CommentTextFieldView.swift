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
    let textField: UITextField = UITextField().withTransperentRoundedCorners(borderColor: UIColor(hexString: "A7B0FF"))
    private let sendButton: UIButton = UIButton(type: .system)
    
    weak var delegate: CommentTextFieldViewDelegate?
    
    let textFieldHeight = CGFloat(34)
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
        profileImageView.snp.makeConstraints { (profileImageView) in
            profileImageView.leading.equalToSuperview().offset(Metrics.doublePadding)
            profileImageView.top.equalToSuperview().offset(Metrics.doublePadding)
            profileImageView.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        profileImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        textField.snp.makeConstraints { (textField) in
            textField.centerY.equalTo(profileImageView.snp.centerY)
            textField.height.equalTo(textFieldHeight)
            textField.leading.equalTo(profileImageView.snp.trailing).offset(Metrics.padding)
            textField.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
        
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
    }
    
    private func setupSendButton() {
        sendButton.titleLabel?.font = Fonts.h10()
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitle("Send".localized, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    @objc func sendButtonPressed() {
        if let massage = textField.text {
            delegate?.commentTextFieldViewSendPressed(self, with: massage)
            textField.text = ""
        }
    }
}
