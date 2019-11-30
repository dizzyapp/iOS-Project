//
//  AdminPlaceAnalyticCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class AdminPlaceAnalyticCell: UITableViewCell {
    
    struct CellData {
        let title: String
        let message: String
    }
    
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addSubviews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupTitleLabel()
        setupMessageLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.h3(weight: .bold)
        titleLabel.textColor = .primeryPurple
        titleLabel.textAlignment = .natural
    }
    
    private func setupMessageLabel() {
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .natural
        messageLabel.font = Fonts.h7()
    }
    
    private func addSubviews() {
        contentView.addSubviews([titleLabel, messageLabel])
    }
    
    private func layoutViews() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metrics.doublePadding * 3)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
            make.top.equalToSuperview().offset(Metrics.padding)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.padding)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
        }
    }
    
    func configure(with cellData: CellData) {
        titleLabel.text = cellData.title
        messageLabel.text = cellData.message
    }
}
