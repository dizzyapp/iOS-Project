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

protocol DiscoveryPlaceCellDelegate: class {
    func discoveryPlaceCellDidPressDetails(_ cell: DiscoveryPlaceCell)
    func discoveryPlaceCellDidPressIcon(_ cell: DiscoveryPlaceCell)
}

class DiscoveryPlaceCell: UICollectionViewCell {
    let placeImageView = PlaceImageView()
    let placeNameLabel = UILabel()
    let placeAddressLabel = UILabel()
    let distanceLabel = UILabel()
    let placeDetailsStackView = UIStackView()
    
    let stackViewTrailingPadding = CGFloat(15)
    let smallLabelsFontSize = CGFloat(10)
    let smallLabelsAlpha = CGFloat(0.618)
    let placeImageViewSize = CGFloat(50)

    weak var delegate: DiscoveryPlaceCellDelegate?
    
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
        
        self.layoutPlaceImageView()
        self.layoutPlaceDetailsStackView()
        self.layoutLabelsInStackView()
    }
    
    private func layoutPlaceImageView() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.leading.equalToSuperview()
            placeImageView.centerY.equalTo(self.snp.centerY)
            placeImageView.width.height.equalTo(placeImageViewSize)
        }
        
        placeImageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func layoutPlaceDetailsStackView() {
        placeDetailsStackView.snp.makeConstraints { placeDetailsStackView in
            placeDetailsStackView.top.bottom.equalTo(placeImageView)
            placeDetailsStackView.leading.equalTo(placeImageView.snp.trailing).offset(stackViewTrailingPadding)
            placeDetailsStackView.trailing.equalToSuperview()
        }
    }
    
    private func layoutLabelsInStackView() {
        placeDetailsStackView.addArrangedSubview(placeNameLabel)
        placeDetailsStackView.addArrangedSubview(placeAddressLabel)
        placeDetailsStackView.addArrangedSubview(distanceLabel)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        setupStackView()
        setupLabels()
        setupPlaceImageView()
    }
    
    private func setupStackView() {
        placeDetailsStackView.axis = .vertical
        placeDetailsStackView.distribution = .equalSpacing
        placeDetailsStackView.contentMode = .center
        placeDetailsStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressDetails)))
    }
    
    private func setupLabels() {
        placeNameLabel.font = Fonts.h10(weight: .bold)
        placeNameLabel.numberOfLines = 1
        placeNameLabel.textAlignment = .left
        
        placeAddressLabel.font = Fonts.medium(size: smallLabelsFontSize)
        placeAddressLabel.numberOfLines = 1
        placeAddressLabel.textAlignment = .left
        placeAddressLabel.alpha = smallLabelsAlpha
        
        distanceLabel.font = Fonts.medium(size: smallLabelsFontSize)
        distanceLabel.numberOfLines = 1
        distanceLabel.textAlignment = .left
        distanceLabel.alpha = smallLabelsAlpha
    }
    
    func setupPlaceImageView() {
        placeImageView.layer.cornerRadius = placeImageViewSize/2
        placeImageView.clipsToBounds = true
        placeImageView.addTarget(self, action: #selector(didPressIcon), for: .touchUpInside)
    }

    func setPlaceInfo(_ placeInfo: PlaceInfo, currentAppLocation: Location?) {
        placeNameLabel.text = placeInfo.name
        placeAddressLabel.text = placeInfo.description
        if let imageURL = URL(string: placeInfo.imageURLString ?? "") {
            placeImageView.setImage(from: imageURL)
        }
        
        if let currentLocation = currentAppLocation {
            distanceLabel.text = String(format: "%.2f km", currentLocation.getDistanceTo(placeInfo.location))
        } else {
            distanceLabel.text = "--"
        }
    }
    
    @objc func didPressDetails() {
        delegate?.discoveryPlaceCellDidPressDetails(self)
    }
    
    @objc func didPressIcon() {
        delegate?.discoveryPlaceCellDidPressIcon(self)
    }
}
