//
//  Chatable .swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class CommentsTextFieldInputView: UIView {
    
    private var stackView = UIStackView()
    private var showHideCommentsView = ShowHideCommentsToggleView()
    private let commentsView = CommentsView()
    private var firstCommentLabel = UILabel()
    private let chatTextFieldView = CommentTextFieldView()
    private let chatTextFieldAccessoryView = CommentTextFieldView()
    private weak var parentView: UIView?
    
    weak var delegate: CommentsManagerDelegate?
    weak var dataSource: CommentsManagerDataSource?

    let cornerRadius: CGFloat = 25.0
    let bottomPadding = CGFloat(27)

    init(parentView: UIView) {
        self.parentView = parentView
        
        addListeners()
        addSubviews()
        layoutViews()
        setupViews()
    }
 
    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        chatTextFieldAccessoryView.textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(showHideCommentsView)
        stackView.addArrangedSubview(commentsView)
        stackView.addArrangedSubview(firstCommentLabel)
        
        parentView?.addSubview(chatTextFieldView)
        parentView?.addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutStackView()
        layoutChatTextFieldView()
        
        parentView?.layoutIfNeeded()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { (stackView) in
            stackView.leading.trailing.equalToSuperview()
            stackView.bottom.equalTo(chatTextFieldView.snp.top).offset(-Metrics.oneAndHalfPadding)
        }
    }
    
    private func layoutShowHideCommentsView() {
        showHideCommentsView.snp.makeConstraints { (showHideCommentsView) in
            showHideCommentsView.width.equalToSuperview().multipliedBy(0.5)
            showHideCommentsView.leading.greaterThanOrEqualToSuperview().offset(Metrics.doublePadding)
            showHideCommentsView.trailing.greaterThanOrEqualToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func layoutChatTextFieldView() {
        chatTextFieldView.snp.makeConstraints { (chatTextFieldView) in
            chatTextFieldView.bottom.equalTo(parentView?.safeAreaLayoutGuide.snp.bottom ?? 0).offset(-bottomPadding)
            chatTextFieldView.leading.trailing.equalToSuperview()
            chatTextFieldView.height.equalTo(50)
        }
    }
    
    private func setupViews() {
        setupStackView()
        setupCommentsView()
        setupChatTextFieldView()
        setupInputAccessoryView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 10
    }
    
    private func setupShowHideCommentsView() {
        showHideCommentsView.toggleState = .show
        showHideCommentsView.addTarget(self, action: #selector(showHideCommentsPressed), for: .touchUpInside)
    }
    
    private func setupCommentsView() {
        commentsView.delegate = self
        commentsView.isHidden = true
        commentsView.dataSource = self
    }
    
    private func setupFirstCommentLabel() {
        firstCommentLabel.text = "Be the first to comment!".localized
        firstCommentLabel.textColor = .white
        if let dataSource = dataSource {
            self.firstCommentLabel.isHidden = dataSource.numberOfRowsInSection() <= 0
        }
    }
    
    private func setupChatTextFieldView() {
        chatTextFieldView.delegate = self
        chatTextFieldAccessoryView.delegate = self
    }
    
    private func setupInputAccessoryView() {
        chatTextFieldAccessoryView.frame = CGRect(x: 0, y: 0, width: chatTextFieldView.frame.width, height: chatTextFieldView.frame.height)
        chatTextFieldView.textField.inputAccessoryView = chatTextFieldAccessoryView
    }
    
    func resetManagerToInitialState() {
        commentsView.isHidden = true
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
    
    @objc private func showHideCommentsPressed() {
        showHideCommentsView.toggleShowHide()
    }
}

extension CommentsManager: CommentsViewDelegate {
    func commentsViewPressed() {
        commentsView.isHidden = true
        chatTextFieldView.textField.text = ""
        chatTextFieldAccessoryView.textField.text = ""
        delegate?.commentView(isHidden: commentsView.isHidden)
        chatTextFieldAccessoryView.textField.resignFirstResponder()
        parentView?.endEditing(true)
    }
}

extension CommentsManager {
    @objc func keyboardWillShow(notification: NSNotification) {
        commentsView.isHidden = false
        chatTextFieldView.isHidden = true
        delegate?.commentView(isHidden: commentsView.isHidden)
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
