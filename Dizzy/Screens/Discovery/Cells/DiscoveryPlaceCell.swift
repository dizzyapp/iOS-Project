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

class DiscoveryPlaceCell: UITableViewCell {
    let placeImageView = PlaceImageView()
    let placeNameLabel = UILabel()
    let placeAddressLabel = UILabel()
    let distanceLabel = UILabel()
    let placeEventView = PlaceEventView()
    let placeDetailsStackView = UIStackView()
    
    let stackViewTrailingPadding = CGFloat(15)
    let smallLabelsFontSize = CGFloat(10)
    let smallLabelsAlpha = CGFloat(0.618)
    let placeImageViewSize = CGFloat(50)

    weak var delegate: DiscoveryPlaceCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews([placeImageView, placeDetailsStackView, placeEventView])
    }
    
    private func layoutViews() {
        
        self.layoutPlaceImageView()
        self.layoutPlaceDetailsStackView()
        self.layoutPlaceEventView()
        self.layoutLabelsInStackView()
    }
    
    private func layoutPlaceImageView() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.top.equalToSuperview().offset(Metrics.padding)
            placeImageView.bottom.equalToSuperview().inset(Metrics.padding)
            placeImageView.leading.equalToSuperview().offset(Metrics.padding)
            placeImageView.width.height.equalTo(placeImageViewSize)
        }
        
        placeImageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func layoutPlaceDetailsStackView() {
        placeDetailsStackView.snp.makeConstraints { placeDetailsStackView in
            placeDetailsStackView.top.bottom.equalTo(placeImageView)
            placeDetailsStackView.leading.equalTo(placeImageView.snp.trailing).offset(stackViewTrailingPadding)
        }
    }
    
    private func layoutLabelsInStackView() {
        placeDetailsStackView.addArrangedSubview(placeNameLabel)
        placeDetailsStackView.addArrangedSubview(placeAddressLabel)
        placeDetailsStackView.addArrangedSubview(distanceLabel)
    }
    
    private func layoutPlaceEventView() {
        placeEventView.snp.makeConstraints { placeEventView in
            placeEventView.centerY.equalToSuperview()
            placeEventView.trailing.equalToSuperview().inset(Metrics.padding)
            placeEventView.leading.equalTo(placeDetailsStackView.snp.trailing).offset(Metrics.padding)
        }
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
    
    func setupPlaceEventView(placeEvent: String?) {
        placeEventView.setEventText(placeEvent)
        if placeEvent != nil {
            placeEventView.isHidden = false
        } else {
            placeEventView.isHidden = true
        }
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
        
        setupPlaceEventView(placeEvent: placeInfo.event)
    }
    
    @objc func didPressDetails() {
        delegate?.discoveryPlaceCellDidPressDetails(self)
    }
    
    @objc func didPressIcon() {
        delegate?.discoveryPlaceCellDidPressIcon(self)
    }
}
