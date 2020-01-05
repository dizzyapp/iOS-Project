//
//  ReservationCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 03/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher

final class ReservationCell: UITableViewCell {
    
    private let iconImageHeight = CGFloat(50)
    
    private let nameLabel = UILabel()
    private let numberOfPeopleLabel = UILabel()
    private let iconImageView = PlaceImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addSubviews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupNameLabel()
        setupNumberOfPeopleLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = .dizzyBlue
        nameLabel.numberOfLines = 1
        nameLabel.font = Fonts.h6(weight: .bold)
    }
    
    private func setupNumberOfPeopleLabel() {
        numberOfPeopleLabel.numberOfLines = 1
        numberOfPeopleLabel.font = Fonts.h6(weight: .bold)
    }
    
    private func addSubviews() {
        contentView.addSubviews([nameLabel, numberOfPeopleLabel, iconImageView])
    }
    
    private func layoutViews() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.padding)
            make.leading.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            make.height.width.equalTo(iconImageHeight)
            make.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(Metrics.padding)
            make.centerY.equalTo(iconImageView)
        }
        
        numberOfPeopleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.triplePadding)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    func configure(with data: ReservationData) {
        numberOfPeopleLabel.text = "\(data.numberOfPeople ?? 0)"
        nameLabel.text = data.clientName
        
        if let url = URL(string: data.iconImageURLString ?? "") {
            iconImageView.setImage(from: url)
        }
    }
}
