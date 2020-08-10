//
//  PlaceProfileView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher

protocol PlaceProfileViewDelegate: class {
    func placeProfileViewAddressButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewGetTaxiButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewCallButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewMenuButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewRequestTableButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewStoryButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewPlaceImagePressed(_ view: PlaceProfileView)
}

final class PlaceProfileView: UIView {
    weak var delegate: PlaceProfileViewDelegate?
    var backgroundView = UIView()
    var placeImageView = PlaceImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var addressButton = UIButton(type: .system)
    var openHoursLabel = UILabel()
    var ageLabel = UILabel()
    var callButton = UIButton(type: .system)
    var requestTableButton = UIButton(type: .system)

    var placeInfo: PlaceInfo?
    var stackView = UIStackView()
    let placeImageViewSize = CGFloat(100)
    let backgroundViewCornerRadius = CGFloat(10)
    let backgroundImageOffset = CGFloat(70)
    
    private let wazeButton = UIButton()
    private let getTaxiButton = UIButton()
    private let locationButtonsStackView = UIStackView()
    private let menuButton = UIButton(type: .system)
    
    private let bookingStackView = UIStackView()

    private let storyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "camera_icon"), for: .normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        locationButtonsStackView.addArrangedSubview(wazeButton)
        locationButtonsStackView.addArrangedSubview(getTaxiButton)
    
        bookingStackView.addArrangedSubview(menuButton)
        bookingStackView.addArrangedSubview(requestTableButton)
        
        stackView.addArrangedSubview(placeImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(addressButton)
        stackView.addArrangedSubview(locationButtonsStackView)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(openHoursLabel)
        stackView.addArrangedSubview(bookingStackView)

        self.addSubviews([backgroundView, stackView, callButton, storyButton])
    }

    private func layoutViews() {
        layoutBackgroundView()
        layoutPlaceImageView()
        layoutCallButton()
        layoutStackView()
        layoutStoryButton()

    }

    private func layoutBackgroundView() {
        backgroundView.snp.makeConstraints { backgroundView in
            backgroundView.top.equalToSuperview().offset(backgroundImageOffset)
            backgroundView.leading.equalToSuperview()
            backgroundView.trailing.equalToSuperview()
            backgroundView.bottom.equalToSuperview()
        }
    }

    private func layoutPlaceImageView() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.width.height.equalTo(placeImageViewSize)
            placeImageView.leading.equalToSuperview().offset(Metrics.fourTimesPadding)
        }
    }

    private func layoutCallButton() {
        callButton.snp.makeConstraints { callButton in
            callButton.top.equalTo(backgroundView.snp.top).offset(Metrics.padding)
            callButton.leading.equalTo(backgroundView.snp.leading).offset(Metrics.padding)
        }
    }

    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.top.equalToSuperview().offset(Metrics.tinyPadding)
            stackView.leading.trailing.equalToSuperview().offset(Metrics.doublePadding)
            stackView.trailing.equalToSuperview().inset(Metrics.doublePadding)
            stackView.bottom.equalToSuperview().inset(Metrics.triplePadding)
        }
    }
    
    private func layoutStoryButton() {
        storyButton.snp.makeConstraints { storyButton in
            storyButton.top.equalTo(backgroundView.snp.top).offset(Metrics.padding)
            storyButton.trailing.equalTo(backgroundView.snp.trailing).offset(-Metrics.padding)
        }
    }
    
    private func setupViews() {
        setupBackgroundView()
        setupPlaceImageView()
        setupCallButton()
        setupStackView()
        setupLocationStackView()
        setupWazeButton()
        setupGetTaxiButton()
        setupTitleLabel()
        setupDescriptionLabel()
        setupAddressButton()
        setupOpenHoursLabel()
        setupAgeLabel()
        setupBookingStackView()
        setupRequestTableButton()
        setupStoryButton()
        setupMenuButton()
    }

    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
        backgroundView.layer.cornerRadius = backgroundViewCornerRadius
    }

    private func setupPlaceImageView() {
        placeImageView.imageSize = placeImageViewSize
        placeImageView.addTarget(self, action: #selector(onPlaceImagePress), for: .touchUpInside)
    }
    
    @objc private func onPlaceImagePress() {
        self.delegate?.placeProfileViewPlaceImagePressed(self)
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
    }
    
    private func setupLocationStackView() {
        locationButtonsStackView.axis = .horizontal
        locationButtonsStackView.alignment = .center
        locationButtonsStackView.spacing = Metrics.padding
        locationButtonsStackView.distribution = .equalSpacing
    }
    
    private func setupWazeButton() {
        wazeButton.setImage(Images.wazeButton(), for: .normal)
        wazeButton.addTarget(self, action: #selector(wazeButtonPressed), for: .touchUpInside)
    }
    
    private func setupGetTaxiButton() {
        getTaxiButton.setImage(Images.getTaxiButton(), for: .normal)
        getTaxiButton.addTarget(self, action: #selector(getTaxiPressed), for: .touchUpInside)
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = Fonts.h4(weight: .bold)
    }

    private func setupDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.font = Fonts.h10()
    }

    private func setupAddressButton() {
        addressButton.setTitleColor(UIColor.black, for: .normal)
        addressButton.titleLabel?.font = Fonts.h9(weight: .bold)
        addressButton.isEnabled = false
    }

    private func setupOpenHoursLabel() {
        openHoursLabel.textAlignment = .center
        openHoursLabel.textColor = .blue
        openHoursLabel.font = Fonts.h8(weight: .medium)
    }

    private func setupAgeLabel() {
        ageLabel.textAlignment = .center
        ageLabel.textColor = .black
        ageLabel.font = Fonts.h10(weight: .medium)
    }

    private func setupCallButton() {
        callButton.setImage(Images.callIcon().withRenderingMode(.alwaysOriginal), for: .normal)
        callButton.addTarget(self, action: #selector(callButtonPressed), for: .touchUpInside)
    }
    
    private func setupBookingStackView() {
        bookingStackView.axis = .horizontal
        bookingStackView.alignment = .trailing
        bookingStackView.spacing = Metrics.doublePadding
        bookingStackView.distribution = .equalSpacing
    }

    private func setupRequestTableButton() {
        requestTableButton.backgroundColor = .blue
        requestTableButton.layer.cornerRadius = 5.0
        requestTableButton.setTitle("RESERVE".localized, for: .normal)
        requestTableButton.setTitleColor(UIColor.white, for: .normal)
        requestTableButton.titleLabel?.font = Fonts.h10(weight: .bold)
        requestTableButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 35,bottom: 10,right: 35)
        requestTableButton.addTarget(self, action: #selector(requestTableButtonPressed), for: .touchUpInside)
        
    }
    
    private func setupMenuButton() {
        menuButton.clipsToBounds = true
        menuButton.setTitle("MENU".localized, for: .normal)
        menuButton.layer.backgroundColor = UIColor.white.cgColor
        menuButton.titleLabel?.font = Fonts.h10(weight: .bold)
        menuButton.setTitleColor(UIColor.blue, for: .normal)
        menuButton.setBorder(borderColor: UIColor.lightGray.withAlphaComponent(0.2), cornerRadius: 5.0)
        menuButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 40,bottom: 10,right: 40)
        menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
    }
    
    private func setupStoryButton() {
        storyButton.addTarget(self, action: #selector(storyButtonPressed), for: .touchUpInside)
    }

    func configure(with place: PlaceInfo) {
        
        self.placeInfo = place
        addressButton.setTitle(place.placeAddress, for: .normal)

        if let imageURLString = place.imageURLString, let imageURL = URL(string: imageURLString) {
            self.placeImageView.setImage(from: imageURL)
        }

        titleLabel.text = place.name
        descriptionLabel.text = place.description
        ageLabel.text = place.authorizedAge
        
        if let dateType = Date().dayType, let time = dateType.getDescription(from: place.placeSchedule) {
            let openHoursFormat = "[Y]: [X]".localized
            var openHourText = openHoursFormat.replacingOccurrences(of: "[X]", with: time)
            openHourText = openHourText.replacingOccurrences(of: "[Y]", with: dateType.rawValue)
            openHoursLabel.text = openHourText
        }
    }
    
    func hideStoryButton() {
        storyButton.isHidden = true
    }
}

extension PlaceProfileView {
    
    @objc private func menuButtonPressed() {
        delegate?.placeProfileViewMenuButtonPressed(self)
    }
    
    @objc private func callButtonPressed() {
        delegate?.placeProfileViewCallButtonPressed(self)
    }
    
    @objc private func requestTableButtonPressed() {
        delegate?.placeProfileViewRequestTableButtonPressed(self)
    }

    @objc private func storyButtonPressed() {
        delegate?.placeProfileViewStoryButtonPressed(self)
    }
    
    @objc private func wazeButtonPressed() {
        delegate?.placeProfileViewAddressButtonPressed(self)
    }
    
    @objc private func getTaxiPressed() {
        delegate?.placeProfileViewGetTaxiButtonPressed(self)
    }
}
