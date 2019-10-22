//
//  CommentCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class CommentCell: UITableViewCell {
    
    let placeImageViewSize = CGFloat(50)
    
    let senderNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = .white
        label.font = Fonts.h5(weight: .bold)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 4
        label.textColor = .white
        label.font = Fonts.h6()
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
        senderPictureImageView.kf.setImage(with: comment.writer.photoURL, placeholder: Images.defaultPlaceAvatar())
        senderNameLabel.text = comment.writer.fullName
    }
    
    private func setupViews() {
        setupImageView()
    }
    
    private func setupImageView() {
        senderPictureImageView.clipsToBounds = true
        senderPictureImageView.layer.cornerRadius = placeImageViewSize / 2
    }
    
    private func addSubViews() {
        contentView.addSubviews([messageLabel, senderNameLabel, senderPictureImageView])
    }
    
    private func layoutSubViews() {
        
        senderPictureImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(Metrics.mediumPadding)
            make.width.height.equalTo(placeImageViewSize)
        }
        
        senderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(senderPictureImageView)
            make.leading.equalTo(senderPictureImageView.snp.trailing).offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.top.equalTo(senderNameLabel.snp.bottom).offset(Metrics.tinyPadding)
            make.trailing.leading.equalTo(senderNameLabel)
        }
    }
}
