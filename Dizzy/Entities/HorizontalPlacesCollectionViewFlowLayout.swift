//
//  HorizontalPlacesCollectionViewFlowLayout.swift
//  Dizzy
//
//  Created by Menashe, Or on 27/02/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

class HorizontalPlacesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 10
        itemSize = CGSize(width: 70, height: 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
