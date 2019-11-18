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
    func profileImagePressed()
}

class UserProfileView: UIView {
    
    weak var delegate: UserProfileViewDelegate?

    let profileImageView = UIImageView()
    let profileNameLabel = UILabel()
    
    let nameColor = UIColor.black.withAlphaComponent(0.53)
    let user: DizzyUser
    
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
        self.addSubviews([profileImageView, profileNameLabel])
    }
    
    private func layoutViews() {
        layoutProfileImageView()
        layoutProfileNameLabel()
    }
    
    private func layoutProfileImageView() {
        profileImageView.snp.makeConstraints { profileImageView in
            profileImageView.top.equalToSuperview()
            profileImageView.centerX.equalToSuperview()
            profileImageView.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func layoutProfileNameLabel() {
        profileNameLabel.snp.makeConstraints { profileNameLabel in
            profileNameLabel.top.equalTo(profileImageView.snp.bottom).offset(Metrics.doublePadding)
            profileNameLabel.centerX.equalTo(profileImageView.snp.centerX)
        }
    }
    
    private func setupViews() {
        setupProfileImageView()
        setupProfileNameLabel()
    }
    
    private func setupProfileImageView() {
        self.profileImageView.contentMode = .center
        
        self.profileImageView.kf.setImage(with: user.photoURL  ?? URL(fileURLWithPath: ""), placeholder: Images.profilePlaceholderIcon())
        
        self.addTapToImage()
    }
    
    private func addTapToImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onProfileImagePressed))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled  = true
    }
    
    private func setupProfileNameLabel() {
        self.profileNameLabel.text = user.fullName
        self.profileNameLabel.textColor = nameColor
        self.profileNameLabel.font = Fonts.h6()
    }
    
    @objc func onProfileImagePressed() {
        delegate?.profileImagePressed()
    }
}
