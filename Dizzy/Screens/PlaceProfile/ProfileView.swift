//
//  ProfileView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher

final class ProfileView: UIView {
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = Fonts.h1()
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = Fonts.h13()
        return label
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .purple
        label.font = Fonts.h13()
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        profileImageView.kf.setImage(with: url,placeholder: Images.defaultPlaceAvatar(), options: [.scaleFactor(UIScreen.main.scale)])
    }
    
    private func addSubviews() {
        addSubviews([profileImageView, titleLabel, descriptionLabel])
    }
    
    private func layoutViews() {
        profileImageView.snp.makeConstraints { make in
            make.center.equalTo(snp.top)
            make.height.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).inset(Metrics.mediumPadding)
            make.leading.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(Metrics.padding)
            make.leading.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
    }
}
