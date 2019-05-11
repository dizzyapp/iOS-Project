//
//  MarkerView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 24/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher

final class PlaceMarkerView: UIView {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    init(imageURL: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        setImage(from: imageURL)
        makeRounded()
        addSubviews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
    }
    
    private func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func makeRounded() {
        layer.cornerRadius = 15.0
        clipsToBounds = true
    }
    
    private func setImage(from imageURLStirng: String) {
        let imageURL = URL(string: imageURLStirng)
        imageView.kf.setImage(with: imageURL, placeholder: Images.defaultPlaceAvatar())
    }
}
