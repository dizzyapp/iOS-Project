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
        label.text = "PlaceHloder"
        return label
    }()
    
    private let publicistButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("call to publicist".localized, for: .normal)
        button.setTitleColor(UIColor.primeryPurple, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 46)
        button.layer.cornerRadius = 16.0
        button.layer.borderColor = UIColor.primeryPurple.cgColor
        button.layer.borderWidth = 1.0
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
    }
    
    func configure(with googlePlace: GooglePlaceData) {
        openHoursLabel.text = googlePlace.openingText
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
        addSubviews([profileImageView, titleLabel, descriptionLabel, ageLabel, openHoursLabel, addressLabel, publicistButton])
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
        
        publicistButton.snp.makeConstraints { make in
            make.top.equalTo(openHoursLabel.snp.bottom).offset(Metrics.padding)
            make.leading.equalToSuperview().offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
        }
    }
    
    @objc func publicistButtonPressed() {
        delegate?.placeProfileViewPublicistButtonPressed(self)
    }
}
