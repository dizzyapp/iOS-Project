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
    func placeProfileViewPublicistButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewWhatsappButtonPressed(_ view: PlaceProfileView)
    func placeProfileViewStoryButtonPressed(_ view: PlaceProfileView)
}

final class PlaceProfileView: UIView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = Fonts.i3(weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = Fonts.h5()
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = UIColor(red: 145, green: 154, blue: 222)
        label.font = Fonts.h5()
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = Fonts.h5()
        return label
    }()
    
    private let openHoursLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = Fonts.h5()
        return label
    }()
    
    private let publicistButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("call".localized, for: .normal)
        button.setTitleColor(UIColor.primeryPurple, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 46)
        button.layer.cornerRadius = 16.0
        button.layer.borderColor = UIColor.primeryPurple.cgColor
        button.layer.borderWidth = 1.0
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    private let sendWhatsappButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("send whatsapp".localized, for: .normal)
        button.setTitleColor(UIColor.primeryPurple, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 46)
        button.layer.cornerRadius = 16.0
        button.layer.borderColor = UIColor.primeryPurple.cgColor
        button.layer.borderWidth = 1.0
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let storyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Story".localized, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    weak var delegate: PlaceProfileViewDelegate?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubviews()
        layoutViews()
        makeRoundedCorners()
        publicistButton.addTarget(self, action: #selector(publicistButtonPressed), for: .touchUpInside)
        sendWhatsappButton.addTarget(self, action: #selector(whatsappButtonPressed), for: .touchUpInside)
        storyButton.addTarget(self, action: #selector(storyButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with place: PlaceInfo) {
        
        place.location.getCurrentAddress { [weak self] address in
            self?.addressLabel.text = "\(address?.street ?? ""), \(address?.city ?? ""), \(address?.country ?? "")"
        }
    
        setupImageView(with: place.imageURLString ?? "")
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
    
    private func setupImageView(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        profileImageView.kf.setImage(with: url,placeholder: Images.defaultPlaceAvatar(), options: [.scaleFactor(UIScreen.main.scale)])
        layoutIfNeeded()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    private func makeRoundedCorners() {
        layer.cornerRadius = 25.0
    }
    
    private func addSubviews() {
        addSubviews([profileImageView, titleLabel, descriptionLabel, ageLabel, openHoursLabel, addressLabel, buttonsStackView, storyButton])
        buttonsStackView.addArrangedSubview(publicistButton)
        buttonsStackView.addArrangedSubview(sendWhatsappButton)
    }
    
    private func layoutViews() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.top)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Metrics.doublePadding)
            make.leading.trailing.equalToSuperview().offset(Metrics.mediumPadding)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.padding)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metrics.padding)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(Metrics.padding)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        openHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(Metrics.padding)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(openHoursLabel.snp.bottom).offset(Metrics.padding)
            make.leading.equalToSuperview().offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
        }
        storyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.mediumPadding)
            make.trailing.equalToSuperview().offset(Metrics.mediumPadding)
        }
    }
    
    @objc func publicistButtonPressed() {
        delegate?.placeProfileViewPublicistButtonPressed(self)
    }
    
    @objc func whatsappButtonPressed() {
        delegate?.placeProfileViewWhatsappButtonPressed(self)
    }
    
    @objc private func storyButtonPressed() {
        delegate?.placeProfileViewStoryButtonPressed(self)
    }
}
