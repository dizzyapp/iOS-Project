//
//  MarkerView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 24/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class PlaceMarkerView: UIView {

    init(imageURL: String) {
        super.init(frame: .zero)
        setImage(from: imageURL)
        makeRounded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeRounded() {
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
    private func setImage(from imageURL: String) {
        
    }
}
