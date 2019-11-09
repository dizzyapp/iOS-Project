//
//  CommentView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsViewDelegate: class {
    func commentPressed()
    func hideCommentsPressed()
    func showCommentsPressed()
}

protocol CommentsViewDataSource: class {
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> CommentWithWriter?
}

final class CommentsView: UIView {
    
    private let tableView = UITableView()
    private let commentsVisabilityButton = UIButton()
    weak var delegate: CommentsViewDelegate?
    weak var dataSource: CommentsViewDataSource?
    private var areCommentsVisible = false
    var tableViewHight: CGFloat {
        return tableView.frame.height
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
        layoutViews()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 20
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        setupTableView()
        setupVisabillityButton()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(CommentCell.self)
    }
    
    private func setupVisabillityButton() {
        commentsVisabilityButton.setImage(Images.slideTab(), for: .normal)
        commentsVisabilityButton.addTarget(self, action: #selector(visabillityButtonPressed), for: .touchUpInside)
    }
    
    private func layoutViews() {
        addSubviews([tableView, commentsVisabilityButton])
        
        commentsVisabilityButton.snp.makeConstraints { commentsVisabilityButton in
            commentsVisabilityButton.top.equalToSuperview().offset(Metrics.tinyPadding)
            commentsVisabilityButton.bottom.equalTo(tableView.snp.top).offset(-Metrics.tinyPadding)
            commentsVisabilityButton.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { tableView in
            tableView.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func viewPressed() {
        delegate?.commentPressed()
    }
    
    func reloadTableView() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        scrollToBottomIfNeeded()
    }
    
    private func scrollToBottomIfNeeded() {
        guard let numberOfRows = dataSource?.numberOfRowsInSection() else { return }
        let lastItem = numberOfRows - 1
        if numberOfRows > 1 {
            let bottomIntextPath = IndexPath(item: lastItem, section: 0)
            tableView.scrollToRow(at: bottomIntextPath, at: .bottom, animated: true)
        }
    }
    
    @objc private func visabillityButtonPressed() {
        if areCommentsVisible {
            self.delegate?.hideCommentsPressed()
        } else {
            self.delegate?.showCommentsPressed()
        }
        
        areCommentsVisible = !areCommentsVisible
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
