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
    
    var imageSize: CGFloat = 50 {
        didSet {
            layoutBackgroundImageView()
        }
    }
    var imageURL: URL? {
        didSet {
            setupImageView()
        }
    }
    
    let backgroundImageInset: CGFloat = 9

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
        setupView()
        setupBackgroundImageView()
        setupImageView()
    }
    
    private func layoutBackgroundImageView() {
        
        backgroundImageView.snp.makeConstraints { backgroundImageView in
            backgroundImageView.centerY.equalToSuperview()
            backgroundImageView.leading.equalToSuperview()
            backgroundImageView.width.height.equalTo(imageSize - backgroundImageInset)
        }
        
        backgroundImageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func layoutImageView() {
        imageView.snp.makeConstraints { imageView in
            imageView.centerX.equalTo(backgroundImageView.snp.centerX)
            imageView.centerY.equalToSuperview()
            imageView.width.height.equalTo(imageSize - backgroundImageInset)
        }
        
        imageView.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    private func setupImageView() {
        self.imageView.layer.cornerRadius = (imageSize - backgroundImageInset)/2
        self.imageView.layer.masksToBounds = true
        self.imageView.kf.setImage(with: imageURL, placeholder: Images.defaultPlaceAvatar())
    }
    
    private func setupBackgroundImageView() {
        self.backgroundImageView.layer.cornerRadius = (imageSize - backgroundImageInset)/2
        self.imageView.layer.masksToBounds = true
        self.backgroundImageView.image = Images.placeBackgroundIcon()
    }
}
