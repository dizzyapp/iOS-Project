//
//  AdminPlaceCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class AdminPlaceCell: UITableViewCell {
    
    let placeNameLabel = UILabel()
    let arrowImageView = UIImageView()
    let seperator = UIView()
    
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
        selectionStyle = .none
        setupPlaceNameLabel()
        setupArrowImageView()
        setupSperator()
    }
    
    private func setupPlaceNameLabel() {
        placeNameLabel.numberOfLines = 1
        placeNameLabel.font = Fonts.h6(weight: .bold)
    }
    
    private func setupArrowImageView() {
        arrowImageView.image = UIImage(named: "rightArrowIcon")
        arrowImageView.contentMode = .scaleAspectFit
    }
    
    private func setupSperator() {
        seperator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    private func layoutViews() {
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metrics.doublePadding * 3)
            make.top.equalToSuperview().offset(Metrics.doublePadding)
            make.bottom.equalToSuperview().inset(Metrics.oneAndHalfPadding)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(Metrics.padding)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.padding)
            make.centerY.equalTo(placeNameLabel.snp.centerY)
        }
        
        let seperatorHeight = 1.0
        seperator.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(Metrics.doublePadding)
            make.leading.equalTo(placeNameLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(seperatorHeight)
        }
    }
    
    private func addSubviews() {
        contentView.addSubviews([placeNameLabel, arrowImageView, seperator])
    }
    
    func configure(with placeInfo: PlaceInfo) {
        placeNameLabel.text = placeInfo.name
    }
}
