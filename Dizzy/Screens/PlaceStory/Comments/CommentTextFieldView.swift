//
//  CommentTextFieldView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class CommentTextFieldView: UIView {
    
    let textField: UITextField  = {
        let textField = UITextField().withTransperentRoundedCorners
        textField.placeholder = "PlaceHolder"
        textField.textAlignment = .natural
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Send".localized, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview()
        layoutViews()
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
}
