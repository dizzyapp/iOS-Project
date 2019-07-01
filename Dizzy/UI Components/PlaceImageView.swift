//
//  PlaceImageView.swift
//  Dizzy
//
//  Created by stas berkman on 29/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class PlaceImageView: UIView {
    
    private var placeImageView = UIImageView()
    private var backgroundImageView = UIImageView()
    private var imageURL: URL?
    
    var imageSize: CGFloat = 45 {
        didSet {
            layoutViews()
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
    
    func setImage(from url: URL) {
        self.imageURL = url
        self.setupPlaceImageView()
    }
    
    private func addSubviews() {
        self.addSubviews([backgroundImageView, placeImageView])
    }
    
    private func layoutViews() {
        layoutBackgroundImageView()
        layoutImageView()
    }
    
    private func setupViews() {
        setupView()
        setupBackgroundImageView()
        setupPlaceImageView()
    }
    
    private func layoutBackgroundImageView() {
        backgroundImageView.snp.makeConstraints { backgroundImageView in
            backgroundImageView.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.top.leading.equalToSuperview().offset(backgroundImageInset)
            placeImageView.trailing.bottom.equalToSuperview().offset(-backgroundImageInset)
        }
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    
    private func setupPlaceImageView() {
        let imageViewWidth: CGFloat = (imageSize - (2 * backgroundImageInset))/2
        self.placeImageView.layer.cornerRadius = imageViewWidth
        self.placeImageView.layer.masksToBounds = true
        self.placeImageView.kf.setImage(with: imageURL, placeholder: Images.defaultPlaceAvatar())
    }
    
    private func setupBackgroundImageView() {
        self.backgroundImageView.layer.cornerRadius = imageSize/2
        self.backgroundImageView.layer.masksToBounds = true
        self.backgroundImageView.image = Images.placeBackgroundIcon()
    }
}
