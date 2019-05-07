//
//  DiscoveryCollectionViewCell.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class DiscoveryPlaceCell: UICollectionViewCell {
    let placeImageView = UIImageView()
    let placeNameLabel = UILabel()
    let placeAddressLabel = UILabel()
    let distanceLabel = UILabel()
    let placeDetailsStackView = UIStackView()
    
    let stackViewTrailingPadding = CGFloat(15)
    let smallLabelsFontSize = CGFloat(8)
    
    init(placeInfo: PlaceInfo) {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews([placeImageView, placeDetailsStackView])
        placeDetailsStackView.addSubviews([placeNameLabel, placeAddressLabel, distanceLabel])
    }
    
    private func layoutViews() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.top.greaterThanOrEqualTo(self.snp.top).offset(Metrics.padding)
            placeImageView.bottom.equalToSuperview().offset(-Metrics.padding)
            placeImageView.leading.equalToSuperview()
            placeImageView.width.height.equalTo(50)
        }
        
        placeImageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        placeDetailsStackView.snp.makeConstraints { placeDetailsStackView in
            placeDetailsStackView.top.bottom.equalTo(placeImageView)
            placeDetailsStackView.leading.equalTo(placeImageView.snp.trailing).offset(stackViewTrailingPadding)
            placeDetailsStackView.trailing.equalToSuperview()
        }
        
        layoutLabelsInStackView()
    }
    
    private func layoutLabelsInStackView() {
        placeDetailsStackView.addArrangedSubview(placeNameLabel)
        placeDetailsStackView.addArrangedSubview(placeAddressLabel)
        placeDetailsStackView.addArrangedSubview(distanceLabel)
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupStackView()
        setupLabels()
        placeImageView.layer.cornerRadius = 25
        placeImageView.clipsToBounds = true
        placeImageView.layer.borderColor = UIColor.black.cgColor
        placeImageView.layer.borderWidth = 2
        
    }
    
    private func setupStackView() {
        placeDetailsStackView.axis = .vertical
        placeDetailsStackView.distribution = .equalSpacing
        placeDetailsStackView.contentMode = .center
    }
    
    private func setupLabels() {
        placeNameLabel.font = Fonts.h12(weight: .bold)
        placeNameLabel.numberOfLines = 1
        placeNameLabel.textAlignment = .left
        
        placeAddressLabel.font = Fonts.regular(size: smallLabelsFontSize)
        placeAddressLabel.numberOfLines = 1
        placeAddressLabel.textAlignment = .left
        
        distanceLabel.font = Fonts.regular(size: smallLabelsFontSize)
        distanceLabel.numberOfLines = 1
        distanceLabel.textAlignment = .left
    }

    func setPlaceInfo(_ placeInfo: PlaceInfo, currentAppLocation: Location?) {
        placeNameLabel.text = placeInfo.name
        placeAddressLabel.text = placeInfo.description
        let imageUrl = URL(string: placeInfo.imageURLString ?? "")
        placeImageView.kf.setImage(with: imageUrl, placeholder: Images.defaultPlaceAvatar())
        
        if let currentLocation = currentAppLocation {
            distanceLabel.text = String(format: "%.2f km", currentLocation.getDistanceTo(placeInfo.location))
        } else {
            distanceLabel.text = "--"
        }
    }
}
