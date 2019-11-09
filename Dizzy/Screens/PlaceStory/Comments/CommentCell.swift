//
//  CommentCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class CommentCell: UITableViewCell {
    
    let userImageViewSize = CGFloat(37.5)
    
    let senderNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = .white
        label.font = Fonts.h8(weight: .bold)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 4
        label.textColor = .white
        label.font = Fonts.h8()
        return label
    }()
    
    let senderPictureImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubViews()
        layoutSubViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: CommentWithWriter) {
        messageLabel.text = comment.comment.value
        senderPictureImageView.kf.setImage(with: comment.writer.photoURL, placeholder: Images.profilePlaceholderIcon())
        senderNameLabel.text = comment.writer.fullName
    }
    
    private func setupViews() {
        setupImageView()
    }
    
    private func setupImageView() {
        senderPictureImageView.clipsToBounds = true
        senderPictureImageView.layer.cornerRadius = userImageViewSize / 2
    }
    
    private func addSubViews() {
        contentView.addSubviews([messageLabel, senderNameLabel, senderPictureImageView])
    }
    
    private func layoutSubViews() {
        
        senderPictureImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(Metrics.doublePadding)
            make.width.height.equalTo(userImageViewSize)
        }
        
        senderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(senderPictureImageView)
            make.leading.equalTo(senderPictureImageView.snp.trailing).offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(senderNameLabel.snp.bottom).offset(Metrics.tinyPadding)
            make.trailing.leading.equalTo(senderNameLabel)
        }
    }
}
