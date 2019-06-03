//
//  Chatable .swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsManagerDelegate: class {
    func commecntView(isHidden: Bool)
}

final class CommentsManager: NSObject {
    
    private let chatTextFieldView = CommentTextFieldView()
    private let chatTextFieldAccessoryView = CommentTextFieldView()
    private let commentsView = CommentsView()
    private weak var parentView: UIView?
    
    weak var delegate: CommentsManagerDelegate?

    init(parentView: UIView) {
        self.parentView = parentView
        super.init()
        setupViews()
    }
 
    private func setupViews() {
        addListeners()
        commentsView.delegate = self
        commentsView.isHidden = true
    }
    
    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        chatTextFieldAccessoryView.textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func setupInputAccessoryView() {
        chatTextFieldAccessoryView.frame = CGRect(x: 0, y: 0, width: chatTextFieldView.frame.width, height: chatTextFieldView.frame.height)
        chatTextFieldView.textField.inputAccessoryView = chatTextFieldAccessoryView
    }
    
    func addCommentsViews() {
        parentView?.addSubviews([chatTextFieldView, commentsView])
        layoutViews()
        setupInputAccessoryView()
    }
    
    private func layoutViews() {
        chatTextFieldView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        commentsView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        parentView?.layoutIfNeeded()
    }
    
    func showTextField(_ show: Bool) {
        chatTextFieldView.isHidden = !show
    }
}

extension CommentsManager {
    @objc func textFieldValueChanged() {
        chatTextFieldView.textField.text = chatTextFieldAccessoryView.textField.text
    }
}

extension CommentsManager: CommentsViewDelegate {
    func commentsViewPressed() {
        commentsView.isHidden = true
        delegate?.commecntView(isHidden: commentsView.isHidden)
        chatTextFieldAccessoryView.textField.resignFirstResponder()
        parentView?.endEditing(true)
    }
}

extension CommentsManager {
    @objc func keyboardWillShow(notification: NSNotification) {
        commentsView.isHidden = false
        delegate?.commecntView(isHidden: commentsView.isHidden)
        chatTextFieldAccessoryView.textField.becomeFirstResponder()
    }
}
