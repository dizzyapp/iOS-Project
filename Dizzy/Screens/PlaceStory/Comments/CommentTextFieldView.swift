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
    
    let textField: UITextField  = {
        let textField = UITextField().withTransperentRoundedCorners
        textField.placeholder = "PlaceHolder".localized
        textField.textAlignment = .natural
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Send".localized, for: .normal)
        return button
    }()
    
    weak var delegate: CommentTextFieldViewDelegate?
    
    init() {
        super.init(frame: .zero)
        addSubview()
        layoutViews()
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func addSubview() {
        addSubviews([textField, sendButton])
    }
    
    private func layoutViews() {
        sendButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Metrics.mediumPadding)
            make.width.equalTo(50)
            make.top.equalToSuperview().offset(Metrics.doublePadding)
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(sendButton)
            make.leading.equalTo(sendButton.snp.trailing).offset(Metrics.mediumPadding)
            make.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
    }
    
    @objc func sendButtonPressed() {
        if let massage = textField.text {
            delegate?.commentTextFieldViewSendPressed(self, with: massage)
            textField.text = ""
        }
    }
}
