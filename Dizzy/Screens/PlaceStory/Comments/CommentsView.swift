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
    
    func reloadTableView() {
        tableView.reloadData()
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
