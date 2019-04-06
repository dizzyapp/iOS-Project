//
//  DiscoveryCollectionViewCell.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

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
            placeImageView.top.bottom.equalToSuperview().offset(Metrics.padding)
            placeImageView.leading.equalToSuperview()
        }
        
        placeDetailsStackView.snp.makeConstraints { placeDetailsStackView in
            placeDetailsStackView.top.bottom.equalTo(placeImageView)
            placeDetailsStackView.leading.equalTo(placeImageView).offset(stackViewTrailingPadding)
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
    }
    
    private func setupStackView() {
        placeDetailsStackView.axis = .vertical
        placeDetailsStackView.distribution = .equalSpacing
        placeDetailsStackView.contentMode = .scaleAspectFit
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

    func setPlaceInfo(_ placeInfo: PlaceInfo) {
        placeNameLabel.text = placeInfo.name
        placeAddressLabel.text = placeInfo.address
        distanceLabel.text = placeInfo.position
    }
}
