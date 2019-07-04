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
    func commentsManagerSendPressed(_ manager: CommentsManager, with message: String)
}

protocol CommentsManagerDataSource: class {
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> Comment?
}

final class CommentsManager: NSObject {
    
    private let chatTextFieldView = CommentTextFieldView()
    private let chatTextFieldAccessoryView = CommentTextFieldView()
    private let commentsView = CommentsView()
    private weak var parentView: UIView?
    
    weak var delegate: CommentsManagerDelegate?
    weak var dataSource: CommentsManagerDataSource?

    let cornerRadius: CGFloat = 25.0

    init(parentView: UIView) {
        self.parentView = parentView
        super.init()
        
        setupViews()
    }
 
    private func setupViews() {
        addListeners()
        setupCommentsView()
        setupChatTextFieldView()
    }
    
    private func setupCommentsView() {
        commentsView.delegate = self
        commentsView.isHidden = true
        commentsView.dataSource = self
    }
    
    private func setupChatTextFieldView() {
        chatTextFieldView.delegate = self
        chatTextFieldAccessoryView.delegate = self
        chatTextFieldView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func resetManagerToInitialState() {
        commentsView.isHidden = true
    }
    
    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        chatTextFieldAccessoryView.textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupInputAccessoryView() {
        chatTextFieldAccessoryView.frame = CGRect(x: 0, y: 0, width: chatTextFieldView.frame.width, height: chatTextFieldView.frame.height)
        chatTextFieldView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        chatTextFieldView.textField.inputAccessoryView = chatTextFieldAccessoryView
    }
    
    func addCommentsViews() {
        parentView?.addSubviews([chatTextFieldView, commentsView])
        layoutViews()
        setupInputView()
    }
    
    private func setupInputView() {
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
    
    func reloadTableView() {
        commentsView.reloadTableView()
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
        chatTextFieldView.textField.text = ""
        chatTextFieldAccessoryView.textField.text = ""
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

extension CommentsManager: CommentTextFieldViewDelegate {
    func commentTextFieldViewSendPressed(_ view: UIView, with message: String) {
        delegate?.commentsManagerSendPressed(self, with: message)
    }
}

extension CommentsManager: CommentsViewDataSource {
    func numberOfRowsInSection() -> Int {
        return dataSource?.numberOfRowsInSection() ?? 0
    }
    
    func comment(at indexPath: IndexPath) -> Comment? {
        return dataSource?.comment(at: indexPath)
    }
}
