//
//  Chatable .swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsTextFieldInputViewDelegate: class {
    func commentView(isHidden: Bool)
    func commentsTextFieldInputViewSendPressed(_ inputView: CommentsTextFieldInputView, with message: String)
}

protocol CommentsTextFieldInputViewDataSource: class {
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> Comment?
}

final class CommentsTextFieldInputView: UIView {
    
    private var stackView = UIStackView()
    private var showHideCommentsView = ShowHideCommentsToggleView()
    private let commentsView = CommentsView()
    private var firstCommentLabel = UILabel()
    private let chatTextFieldView = CommentTextFieldView()
    private let chatTextFieldAccessoryView = CommentTextFieldView()
    private weak var parentView: UIView?
    
    weak var delegate: CommentsTextFieldInputViewDelegate?
    weak var dataSource: CommentsTextFieldInputViewDataSource?

    let cornerRadius: CGFloat = 25.0
    let bottomPadding = CGFloat(27)

    init() {
        super.init(frame: .zero)
        
        addListeners()
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
        guard let parentView = self.parentView else {
            return
        }
        
        stackView.snp.makeConstraints { (stackView) in
            stackView.leading.trailing.equalTo(parentView)
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
        guard let parentView = self.parentView else {
            return
        }
        chatTextFieldView.snp.makeConstraints { (chatTextFieldView) in
            chatTextFieldView.bottom.equalTo(parentView.safeAreaLayoutGuide.snp.bottom ).offset(-bottomPadding)
            chatTextFieldView.leading.trailing.equalTo(parentView)
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

extension CommentsTextFieldInputView {
    @objc func textFieldValueChanged() {
        chatTextFieldView.textField.text = chatTextFieldAccessoryView.textField.text
    }
    
    @objc private func showHideCommentsPressed() {
        showHideCommentsView.toggleShowHide()
    }
}

extension CommentsTextFieldInputView: CommentsViewDataSource {
    func numberOfRowsInSection() -> Int {
        return dataSource?.numberOfRowsInSection() ?? 0
    }
    
    func comment(at indexPath: IndexPath) -> Comment? {
        return dataSource?.comment(at: indexPath)
    }
}

extension CommentsTextFieldInputView {
    @objc func keyboardWillShow(notification: NSNotification) {
        commentsView.isHidden = false
        chatTextFieldView.isHidden = true
        delegate?.commentView(isHidden: commentsView.isHidden)
        chatTextFieldAccessoryView.textField.becomeFirstResponder()
    }
}

extension CommentsTextFieldInputView: CommentTextFieldViewDelegate {
    func commentTextFieldViewSendPressed(_ view: UIView, with message: String) {
        delegate?.commentsTextFieldInputViewSendPressed(self, with: message)
    }
}
