//
//  CommentsTextField.swift
//  Dizzy
//
//  Created by Menashe, Or on 13/08/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsTextFieldDelegate: class {
    func sendPressed()
}

class CommentsTextField: UIView {
    weak var delegate: CommentsTextFieldDelegate?
    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    var text: String {
        set {textField.text = newValue}
        get {return textField.text ?? ""}
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        addSubviews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        setupSendButton()
        setupTextField()
    }
    
    private func setupSendButton() {
        sendButton.titleLabel?.font = Fonts.h10()
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitle("Send".localized, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    private func setupTextField() {
        textField.textColor = UIColor.white
        textField.font = Fonts.h8()
        textField.attributedPlaceholder = NSAttributedString(string: "Comment...".localized,
                                                             attributes: [.foregroundColor: UIColor.white])
    }
    
    private func addSubviews() {
        addSubviews([textField, sendButton])
    }
    
    private func layoutViews() {
        layoutTextField()
        layoutSendButton()
    }
    
    private func layoutTextField() {
        textField.snp.makeConstraints { textField in
            textField.top.bottom.equalToSuperview()
            textField.leading.equalToSuperview().offset(Metrics.padding)
            textField.trailing.equalTo(sendButton.snp.leading)
        }
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func layoutSendButton() {
        sendButton.snp.makeConstraints { sendButton in
            sendButton.top.bottom.equalToSuperview()
            sendButton.trailing.equalToSuperview().offset(-Metrics.padding)
        }
        
        sendButton.setContentCompressionResistancePriority(UILayoutPriority(900), for: .horizontal)
        sendButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    @objc private func sendButtonPressed() {
        delegate?.sendPressed()
    }
}