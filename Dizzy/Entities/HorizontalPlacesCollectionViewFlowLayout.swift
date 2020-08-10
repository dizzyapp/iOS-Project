//
//  HorizontalPlacesCollectionViewFlowLayout.swift
//  Dizzy
//
//  Created by Menashe, Or on 27/02/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

class HorizontalPlacesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    init(itemSize: CGSize = CGSize(width: 65, height: 80)) {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 10
        self.itemSize = itemSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
