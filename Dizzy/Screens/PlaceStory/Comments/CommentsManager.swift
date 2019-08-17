//
//  CommentsManager.swift
//  Dizzy
//
//  Created by stas berkman on 06/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsManagerDelegate: class {
    func commentView(isHidden: Bool)
    func commentsManagerSendPressed(_ manager: CommentsManager, with message: String)
}

protocol CommentsManagerDataSource: class {
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> Comment?
}

class CommentsManager: NSObject {
    let commentTextFieldView = CommentTextFieldView()
    let commentsTextFieldInputView = CommentsTextFieldInputView()
    
    weak var delegate: CommentsManagerDelegate?
    weak var dataSource: CommentsManagerDataSource?
    
    private weak var parentView: UIView?

    init(parentView: UIView) {
        self.parentView = parentView
        super.init()
        
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    private func addSubviews() {
        self.parentView?.addSubview(commentTextFieldView)
    }
    
    private func layoutViews() {
        commentTextFieldView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.parentView!.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupViews() {
        setupCommentTextFieldView()
    }
    
    private func setupCommentTextFieldView() {
        commentTextFieldView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func reloadTableView() {
        commentsTextFieldInputView.reloadTableView()
    }
}
