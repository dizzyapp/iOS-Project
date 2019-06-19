//
//  UserProfileView.swift
//  Dizzy
//
//  Created by stas berkman on 13/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileView: UIView {

    let profileImageView = UIImageView()
    let profileNameLabel = UILabel()
    
    let nameColor = UIColor.black.withAlphaComponent(0.53)
    
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
            profileImageView.width.equalTo(100)
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
        self.profileImageView.kf.setImage(with: URL(fileURLWithPath: ""), placeholder: Images.profilePlaceholderIcon())
    }
    
    private func setupProfileNameLabel() {
        self.profileNameLabel.text = "Test User".localized
        self.profileNameLabel.textColor = nameColor
        self.profileNameLabel.font = Fonts.h6()
    }
}
