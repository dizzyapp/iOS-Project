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
    
    var placeImageView = PlaceImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var addressButton = UIButton(type: .system)
    var openHoursLabel = UILabel()
    var ageLabel = UILabel()
    var callButton = UIButton()
    var requestTableButton = UIButton(type: .system)
    
    var stackView = UIStackView()
    
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

        self.addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutStackView()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupView()
        setupStackView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupAddressButton()
        setupOpenHoursLabel()
        setupAgeLabel()
        setupCallButton()
        setupRequestTableButton()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 25.0
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = Fonts.i3(weight: .bold)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = Fonts.h5()
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
