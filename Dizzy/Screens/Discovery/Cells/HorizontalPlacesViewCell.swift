//
//  HorizontalPlacesViewCell.swift
//  Dizzy
//
//  Created by Menashe, Or on 27/02/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

class HorizontalPlacesViewCell: UICollectionViewCell {
    
    let placeImage = PlaceImageView()
    let placeNameLabel = UILabel()
    let placeImageViewSize: CGFloat = 65
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
        layoutViews()
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutViews()
        setupViews()
    }
    
    func addViews() {
        contentView.addSubviews([placeImage, placeNameLabel])
    }
    
    func layoutViews() {
        placeImage.snp.makeConstraints { placeImage in
            placeImage.top.equalToSuperview()
            placeImage.centerX.equalToSuperview()
            placeImage.bottom.equalTo(placeNameLabel.snp.top).offset(Metrics.tinyPadding)
            placeImage.width.height.equalTo(placeImageViewSize)
        }
        
        placeNameLabel.snp.makeConstraints { placeNameLabel in
            placeNameLabel.leading.equalTo(placeImage.snp.leading)
            placeNameLabel.trailing.equalTo(placeImage.snp.trailing)
            placeNameLabel.bottom.equalToSuperview()
        }
    }
    
    func setupViews() {
        setupPlaceImageView()
        setupNameLabel()
    }
    
    func setupPlaceImageView() {
        placeImage.layer.cornerRadius = placeImageViewSize/2
        placeImage.imageSize = placeImageViewSize
        placeImage.clipsToBounds = true
        placeImage.addTarget(self, action: #selector(didPressIcon), for: .touchUpInside)
    }
    
    func setupNameLabel() {
        placeNameLabel.font = Fonts.h11(weight: .bold)
        placeNameLabel.textColor = .white
        placeNameLabel.textAlignment = .center
    }
    
    func setPlaceInfo(_ placeInfo: PlaceInfo) {
        if let imageUrl = URL(string: placeInfo.imageURLString ?? "") {
                placeImage.setImage(from: imageUrl)
        }
        
        placeNameLabel.text = placeInfo.name
    }
    
    @objc func didPressIcon() {
        
    }
    
}
