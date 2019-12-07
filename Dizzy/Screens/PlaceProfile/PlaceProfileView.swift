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
    func placeProfileViewCallButtonPressed(_ view: PlaceProfileView)
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
    let placeImageViewSize = CGFloat(115)
    let backgroundViewCornerRadius = CGFloat(25)
    let backgroundImageOffset = CGFloat(40)

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
        stackView.addArrangedSubview(placeImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(addressButton)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(openHoursLabel)
        stackView.addArrangedSubview(requestTableButton)

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
            stackView.leading.trailing.equalToSuperview()
            stackView.bottom.equalToSuperview().offset(-Metrics.doublePadding)
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
        setupTitleLabel()
        setupDescriptionLabel()
        setupAddressButton()
        setupOpenHoursLabel()
        setupAgeLabel()
        setupRequestTableButton()
        setupStoryButton()
    }

    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
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
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = Fonts.h1(weight: .bold)
    }

    private func setupDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.font = Fonts.h8()
    }

    private func setupAddressButton() {
        addressButton.setTitleColor(UIColor.blue, for: .normal)
        addressButton.titleLabel?.font = Fonts.h8(weight: .bold)
        addressButton.addTarget(self, action: #selector(addressButtonPressed), for: .touchUpInside)
    }

    private func setupOpenHoursLabel() {
        openHoursLabel.textAlignment = .center
        openHoursLabel.textColor = .black
        openHoursLabel.font = Fonts.h8()
    }

    private func setupAgeLabel() {
        ageLabel.textAlignment = .center
        ageLabel.textColor = .black
        ageLabel.font = Fonts.h4()
    }

    private func setupCallButton() {
        callButton.setImage(Images.callIcon().withRenderingMode(.alwaysOriginal), for: .normal)
        callButton.addTarget(self, action: #selector(callButtonPressed), for: .touchUpInside)
    }

    private func setupRequestTableButton() {
        requestTableButton.setBackgroundImage(Images.requestTableIcon(), for: .normal)
        requestTableButton.setTitle("RESERVE".localized, for: .normal)
        requestTableButton.setTitleColor(UIColor.white, for: .normal)
        requestTableButton.titleLabel?.font = Fonts.h5(weight: .bold)
        requestTableButton.addTarget(self, action: #selector(requestTableButtonPressed), for: .touchUpInside)
    }
    
    private func setupStoryButton() {
        storyButton.addTarget(self, action: #selector(storyButtonPressed), for: .touchUpInside)
    }

    func configure(with place: PlaceInfo) {
        
        self.placeInfo = place
        place.location.getCurrentAddress { [weak self] address in
            let title: String = "\(address?.street ?? ""), \(address?.city ?? ""), \(address?.country ?? "")"
            self?.addressButton.setTitle(title, for: .normal)
        }

        if let imageURLString = place.imageURLString, let imageURL = URL(string: imageURLString) {
            self.placeImageView.setImage(from: imageURL)
        }

        titleLabel.text = place.name
        descriptionLabel.text = place.description
        ageLabel.text = place.authorizedAge
        
        if let dateType = Date().dayType, let time = dateType.getTime(from: place.placeSchedule) {
            let openHoursFormat = "[Y] hours: [X]".localized
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
    @objc func addressButtonPressed() {
        delegate?.placeProfileViewAddressButtonPressed(self)
    }

    @objc func callButtonPressed() {
        delegate?.placeProfileViewCallButtonPressed(self)
    }
    
    @objc func requestTableButtonPressed() {
        delegate?.placeProfileViewRequestTableButtonPressed(self)
    }

    @objc private func storyButtonPressed() {
        delegate?.placeProfileViewStoryButtonPressed(self)
    }
}
