//
//  PlaceImageView.swift
//  Dizzy
//
//  Created by stas berkman on 29/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class PlaceImageView: UIView {
    
    var imageView = UIImageView()
    var backgroundImageView = UIImageView()
    
    var backgroundImageSize = CGSize(width: 50, height: 50) {
        didSet {
            layoutBackgroundImageView()
        }
    }
    var imageSize = CGSize(width: 41, height: 41) {
        didSet {
            layoutImageView()
        }
    }
    var imageURL: URL? {
        didSet {
            setupImageView()
        }
    }

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
        self.addSubviews([backgroundImageView, imageView])
    }
    
    private func layoutViews() {
        layoutBackgroundImageView()
        layoutImageView()
    }
    
    private func setupViews() {
        setupBackgroundImageView()
        setupImageView()
    }
    
    private func layoutBackgroundImageView() {
        
        backgroundImageView.snp.makeConstraints { backgroundImageView in
            backgroundImageView.centerY.equalToSuperview()
            backgroundImageView.leading.equalToSuperview()
            backgroundImageView.width.height.equalTo(backgroundImageSize)
        }
        
        backgroundImageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func layoutImageView() {
        imageView.snp.makeConstraints { imageView in
            imageView.centerX.equalTo(backgroundImageView.snp.centerX)
            imageView.centerY.equalToSuperview()
            imageView.width.height.equalTo(imageSize)
        }
        
        imageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func setupImageView() {
        self.imageView.layer.cornerRadius = imageSize.width/2
        self.imageView.layer.masksToBounds = true
        self.imageView.kf.setImage(with: imageURL, placeholder: Images.defaultPlaceAvatar())
    }
    
    private func setupBackgroundImageView() {
        self.backgroundImageView.layer.cornerRadius = backgroundImageSize.width/2
        self.imageView.layer.masksToBounds = true
        self.backgroundImageView.image = Images.placeBackgroundIcon()
    }
}
