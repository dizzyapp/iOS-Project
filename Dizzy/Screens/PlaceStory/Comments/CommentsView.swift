//
//  CommentView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsViewDelegate: class {
    func commentsViewPressed()
}

protocol CommentsViewDataSource: class {
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> Comment?
}

final class CommentsView: UIView {
    
    let tableView = UITableView()
    let spaceView = UIView()
    
    weak var delegate: CommentsViewDelegate?
    weak var dataSource: CommentsViewDataSource?
 
    init() {
        super.init(frame: .zero)
        addDarkBlur()
        setupTableView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(CommentCell.self)
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func viewPressed() {
        delegate?.commentsViewPressed()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardSize = keyboardFrame.cgSizeValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        tableView.contentInset = contentInsets
        scrollToBottom()
    }
    
    func reloadTableView() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        guard let numberOfRows = dataSource?.numberOfRowsInSection() else { return }
        let lastItem = numberOfRows - 1
        let bottomIntextPath = IndexPath(item: lastItem, section: 0)
        tableView.scrollToRow(at: bottomIntextPath, at: .bottom, animated: true)
    }
}

extension CommentsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comment = dataSource?.comment(at: indexPath) else { return UITableViewCell() }
        let cell: CommentCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: comment)
        return cell
    }
}
