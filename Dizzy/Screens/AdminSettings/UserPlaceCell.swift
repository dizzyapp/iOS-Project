//
//  UserPlaceCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class UserPlaceCell: UITableViewCell {
    
    let placeNameLabel = UILabel()
    let arrowImageView = UIImageView()
    
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
        setupPlaceNameLabel()
        setupArrowImageView()
    }
    
    private func setupPlaceNameLabel() {
        placeNameLabel.numberOfLines = 1
        placeNameLabel.font = Fonts.h6(weight: .bold)
    }
    
    private func setupArrowImageView() {
        arrowImageView.image = UIImage(named: "")
        arrowImageView.contentMode = .scaleAspectFit
    }
    
    private func layoutViews() {
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            make.top.equalToSuperview().offset(Metrics.padding)
            make.bottom.equalToSuperview().inset(Metrics.oneAndHalfPadding)
            make.trailing.equalTo(arrowImageView.snp.leading).inset(Metrics.padding)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.padding)
            make.top.bottom.equalToSuperview().offset(Metrics.padding)
        }
    }
    
    private func addSubviews() {
        contentView.addSubviews([placeNameLabel, arrowImageView])
    }
    
    func configure(with placeInfo: PlaceInfo) {
        placeNameLabel.text = placeInfo.name
    }
}
