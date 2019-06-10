//
//  CommentCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class CommentCell: UITableViewCell {
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 4
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubViews()
        layoutSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        messageLabel.text = comment.value
    }
    
    private func addSubViews() {
        contentView.addSubviews([messageLabel])
    }
    
    private func layoutSubViews() {
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(Metrics.tinyPadding)
            make.leading.trailing.equalTo(Metrics.mediumPadding)
        }
    }
}
