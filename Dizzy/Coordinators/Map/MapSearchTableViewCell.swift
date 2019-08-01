//
//  MapSearchTableViewCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class MapSearchTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: PlaceInfo) {
        titleLabel.text = data.name
        subtitleLabel.text = data.description
    }
    
    private func addSubviews() {
        contentView.addSubviews([titleLabel, subtitleLabel])
    }
    
    private func layoutViews() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metrics.doublePadding)
            make.top.equalToSuperview().offset(Metrics.mediumPadding)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.mediumPadding)
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview().offset(Metrics.mediumPadding)
        }
    }
}
