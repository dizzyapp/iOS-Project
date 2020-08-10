//
//  PlaceInfoView.swift
//  Dizzy
//
//  Created by Menashe, Or on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol PlaceInfoViewDelegate: class {
    func placeInfoViewDidPressDetails(_ placeInfo: PlaceInfo)
    func placeInfoViewDidPressIcon(_ placeInfo: PlaceInfo)
    func placeInfoDidPressReservationButton(_ placeInfo: PlaceInfo)
}

class PlaceInfoView: UIView {
    let reservationButton = UIButton(type: .system)
    let placeImageView = PlaceImageView()
    let placeNameLabel = UILabel()
    let placeAddressLabel = UILabel()
    let distanceLabel = UILabel()
    let placeDetailsStackView = UIStackView()
    
    let stackViewTrailingPadding = CGFloat(15)
    let smallLabelsFontSize = CGFloat(10)
    let placeImageViewSize = CGFloat(50)
    let reservationButtonHeight = CGFloat(35)
    
    var placeInfo: PlaceInfo?
    
    weak var delegate: PlaceInfoViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubviews([placeImageView, placeDetailsStackView, reservationButton])
        placeDetailsStackView.addSubviews([placeNameLabel, placeAddressLabel, distanceLabel])
    }
    
    private func layoutViews() {
        
        self.layoutPlaceImageView()
        self.layoutPlaceDetailsStackView()
        self.layoutLabelsInStackView()
        self.layoutReservationButton()
    }
    
    private func layoutPlaceImageView() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.leading.equalToSuperview().offset(Metrics.padding)
            placeImageView.width.height.equalTo(placeImageViewSize)
            placeImageView.top.equalToSuperview().offset(Metrics.doublePadding)
            placeImageView.bottom.equalToSuperview().offset(-Metrics.doublePadding)
        }
        
        placeImageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func layoutPlaceDetailsStackView() {
        placeDetailsStackView.snp.makeConstraints { placeDetailsStackView in
            placeDetailsStackView.top.bottom.equalTo(placeImageView)
            placeDetailsStackView.leading.equalTo(placeImageView.snp.trailing).offset(stackViewTrailingPadding)
            placeDetailsStackView.trailing.equalTo(reservationButton.snp.leading)
            placeDetailsStackView.height.equalTo(120)
        }
    }
    
    private func layoutLabelsInStackView() {
        placeDetailsStackView.addArrangedSubview(placeNameLabel)
        placeDetailsStackView.addArrangedSubview(placeAddressLabel)
        placeDetailsStackView.addArrangedSubview(distanceLabel)
    }
    
    private func layoutReservationButton() {
        reservationButton.snp.makeConstraints { reservationButton in
            reservationButton.trailing.equalToSuperview().offset(-Metrics.tinyPadding)
            reservationButton.centerY.equalToSuperview()
            reservationButton.width.equalTo(100)
            reservationButton.height.equalTo(reservationButtonHeight)
        }
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupStackView()
        setupLabels()
        setupPlaceImageView()
        setupReservationButton()
    }
    
    private func setupStackView() {
        placeDetailsStackView.axis = .vertical
        placeDetailsStackView.distribution = .equalSpacing
        placeDetailsStackView.contentMode = .center
        placeDetailsStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressDetails)))
        
        let button = UIButton(type: .system)
        addSubview(button)
        button.snp.makeConstraints { button in
            button.edges.equalTo(placeDetailsStackView.snp.edges)
        }
        button.addTarget(self, action: #selector(didPressDetails), for: .touchUpInside)
    }
    
    private func setupLabels() {
        placeNameLabel.font = Fonts.h8(weight: .bold)
        placeNameLabel.numberOfLines = 1
        placeNameLabel.textAlignment = .left
        
        placeAddressLabel.font = Fonts.medium(size: smallLabelsFontSize)
        placeAddressLabel.numberOfLines = 1
        placeAddressLabel.textAlignment = .left
        
        distanceLabel.font = Fonts.medium(size: smallLabelsFontSize)
        distanceLabel.numberOfLines = 1
        distanceLabel.textAlignment = .left
    }
    
    func setupPlaceImageView() {
        placeImageView.layer.cornerRadius = placeImageViewSize/2
        placeImageView.clipsToBounds = true
        placeImageView.addTarget(self, action: #selector(didPressIcon), for: .touchUpInside)
    }
    
    private func setupReservationButton() {
        reservationButton.setTitle("RESERVE".localized, for: .normal)
        reservationButton.setTitleColor(.white, for: .normal)
        reservationButton.titleLabel?.font = Fonts.h10(weight: .bold)
        reservationButton.setBorder(borderColor: UIColor.lightGray.withAlphaComponent(0.4), cornerRadius: 3)
        reservationButton.backgroundColor = UIColor.blue
        reservationButton.addTarget(self, action: #selector(didPressReservationButton), for: .touchUpInside)
    }
    
    func setPlaceInfo(_ placeInfo: PlaceInfo, currentAppLocation: Location?) {
        self.placeInfo = placeInfo
        placeNameLabel.text = placeInfo.name
        placeAddressLabel.text = placeInfo.description
        if let imageURL = URL(string: placeInfo.imageURLString ?? "") {
            placeImageView.setImage(from: imageURL)
        }
        
        if let currentLocation = currentAppLocation {
            distanceLabel.text = String(format: "%.2f km", currentLocation.getDistanceTo(placeInfo.location))
        } else {
            distanceLabel.text = "..."
        }
    }
    
    @objc func didPressDetails() {
        guard let placeInfo = self.placeInfo else { return }
        delegate?.placeInfoViewDidPressDetails(placeInfo)
    }
    
    @objc func didPressIcon() {
        guard let placeInfo = self.placeInfo else { return }
        delegate?.placeInfoViewDidPressIcon(placeInfo)
    }
    
    @objc func didPressReservationButton() {
        guard let placeInfo = self.placeInfo else { return }
        delegate?.placeInfoDidPressReservationButton(placeInfo)
    }
}
