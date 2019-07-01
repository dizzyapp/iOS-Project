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
    
    var imageSize: CGFloat = 45 {
        didSet {
            layoutViews()
        }
    }
    var imageURL: URL? {
        didSet {
            setupImageView()
        }
    }
    
    let backgroundImageInset: CGFloat = 4

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
            backgroundImageView.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        imageView.snp.makeConstraints { imageView in
            imageView.top.leading.equalToSuperview().offset(backgroundImageInset)
            imageView.trailing.bottom.equalToSuperview().offset(-backgroundImageInset)
        }
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    private func setupImageView() {
        let imageViewWidth: CGFloat = (imageSize - (2 * backgroundImageInset))/2
        self.imageView.layer.cornerRadius = imageViewWidth
        self.imageView.layer.masksToBounds = true
        self.imageView.kf.setImage(with: imageURL, placeholder: Images.defaultPlaceAvatar())
    }
    
    private func setupBackgroundImageView() {
        self.backgroundImageView.layer.cornerRadius = imageSize/2
        self.backgroundImageView.layer.masksToBounds = true
        self.backgroundImageView.image = Images.placeBackgroundIcon()
    }
}
