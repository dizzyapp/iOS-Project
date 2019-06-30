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
}

final class PlaceProfileView: UIView {
    
    var backgroundView = UIView()
    var placeImageView = PlaceImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var addressButton = UIButton(type: .system)
    var openHoursLabel = UILabel()
    var ageLabel = UILabel()
    var callButton = UIButton()
    var requestTableButton = UIButton(type: .system)
    
    var stackView = UIStackView()
    let placeImageViewSize = CGFloat(61)
    let backgroundViewCornerRadius = CGFloat(25)
    
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
        stackView.addArrangedSubview(openHoursLabel)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(callButton)
        stackView.addArrangedSubview(requestTableButton)

        self.addSubview(backgroundView)
        self.addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutBackgroundView()
        layoutStackView()
    }
    
    private func layoutBackgroundView() {
        backgroundView.snp.makeConstraints { backgroundView in
            backgroundView.top.equalToSuperview().offset(25)
            backgroundView.leading.equalToSuperview()
            backgroundView.trailing.equalToSuperview()
            backgroundView.bottom.equalToSuperview()
        }
    }
    
    private func layoutPlaceImageView() {
        stackView.snp.makeConstraints { stackView in
            stackView.width.height.equalTo(placeImageViewSize)
        }
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.top.leading.trailing.equalToSuperview()
            stackView.bottom.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func setupViews() {
        setupBackgroundView()
        setupPlaceImageView()
        setupStackView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupAddressButton()
        setupOpenHoursLabel()
        setupAgeLabel()
        setupCallButton()
        setupRequestTableButton()
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        backgroundView.layer.cornerRadius = backgroundViewCornerRadius
        backgroundView.backgroundColor = .green
    }
    
    private func setupPlaceImageView() {
        placeImageView.imageSize = placeImageViewSize
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.backgroundColor = .red
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = Fonts.i3(weight: .bold)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = Fonts.h10()
    }
    
    private func setupAddressButton() {
        addressButton.setBackgroundImage(Images.addressBackgroundIcon(), for: .normal)
        addressButton.setTitleColor(UIColor(hexString: "A7B0FF"), for: .normal)
        addressButton.titleLabel?.font = Fonts.h5()
        addressButton.addTarget(self, action: #selector(addressButtonPressed), for: .touchUpInside)
    }
    
    private func setupOpenHoursLabel() {
        openHoursLabel.textAlignment = .center
        openHoursLabel.textColor = .white
        openHoursLabel.font = Fonts.h5()
    }
    
    private func setupAgeLabel() {
        ageLabel.textAlignment = .center
        ageLabel.textColor = .white
        ageLabel.font = Fonts.h5()
    }
    
    private func setupCallButton() {
        callButton.setImage(Images.facebookIcon(), for: .normal)
        callButton.addTarget(self, action: #selector(callButtonPressed), for: .touchUpInside)
    }
    
    private func setupRequestTableButton() {
        requestTableButton.setBackgroundImage(Images.requestTableIcon(), for: .normal)
        requestTableButton.setTitle("Request a table".localized, for: .normal)
        requestTableButton.setTitleColor(UIColor(hexString: "C2A7FF"), for: .normal)
        requestTableButton.titleLabel?.font = Fonts.h8()
    }
    
    weak var delegate: PlaceProfileViewDelegate?
    
    func configure(with place: PlaceInfo) {
        
        place.location.getCurrentAddress { [weak self] address in
            let title: String = "\(address?.street ?? ""), \(address?.city ?? ""), \(address?.country ?? "")"
            self?.addressButton.setTitle(title, for: .normal)
        }
    
        if let imageURLString = place.imageURLString {
            self.placeImageView.imageURL = URL(string: imageURLString)
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
}

extension PlaceProfileView {
    @objc func addressButtonPressed() {
        delegate?.placeProfileViewAddressButtonPressed(self)
    }
    
    @objc func callButtonPressed() {
        delegate?.placeProfileViewCallButtonPressed(self)
    }
}
