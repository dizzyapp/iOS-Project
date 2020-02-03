//
//  UserProfileView.swift
//  Dizzy
//
//  Created by stas berkman on 13/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher

protocol UserProfileViewDelegate: class {
    func profileButtonPressed()
}

class UserProfileView: UIView {

    let profileButton = UIButton()
    let profileNameLabel = UILabel()

    weak var delegate: UserProfileViewDelegate?

    let nameColor = UIColor.dizzyBlue
    let user: DizzyUser
    let profileButtonWidth: CGFloat = 80

    init(user: DizzyUser) {
        self.user = user
        super.init(frame: CGRect.zero)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([profileButton, profileNameLabel])
    }
    
    private func layoutViews() {
        layoutProfileImageView()
        layoutProfileNameLabel()
    }
    
    private func layoutProfileImageView() {
        profileButton.snp.makeConstraints { profileButton in
            profileButton.top.equalToSuperview()
            profileButton.centerX.equalToSuperview()
            profileButton.width.equalTo(profileButtonWidth)
            profileButton.height.equalTo(profileButtonWidth)
        }
    }
    
    private func layoutProfileNameLabel() {
        profileNameLabel.snp.makeConstraints { profileNameLabel in
            profileNameLabel.top.equalTo(profileButton.snp.bottom).offset(Metrics.doublePadding)
            profileNameLabel.centerX.equalTo(profileButton.snp.centerX)
        }
    }
    
    private func setupViews() {
        setupProfileButton()
        setupProfileNameLabel()
    }
    
    private func setupProfileButton() {
        self.profileButton.layer.cornerRadius = profileButtonWidth / 2
        self.profileButton.layer.masksToBounds = true
        self.profileButton.contentMode = .center
        self.profileButton.kf.setImage(with: user.photoURL, for: .normal, placeholder: Images.profilePlaceholderIcon())
        self.profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
    }
    
    private func setupProfileNameLabel() {
        self.profileNameLabel.text = user.fullName
        self.profileNameLabel.textColor = nameColor
        self.profileNameLabel.font = Fonts.h4(weight: .bold)
    }

    public func updateProfileImage(_ image: UIImage) {
        self.profileButton.kf.base.setImage(image, for: .normal)
    }
}

extension UserProfileView {
    @objc private func profileButtonPressed() {
        self.delegate?.profileButtonPressed()
    }
}
