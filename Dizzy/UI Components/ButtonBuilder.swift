//
//  ButtonBuilder.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension UIButton {
    
    var smallRoundedBlackButton: UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16.0
        return button
    }
    
    var navigaionCloseButton: UIButton {
        let button = UIButton()
        let image = UIImage(named: "exitStoryButton")
        button.setImage(image, for: .normal)
        return button
    }
    
    var roundedSearchButton: UIButton {
        let button = UIButton()
        let image = UIImage(named: "searchIcon")
        button.setImage(image, for: .normal)
        return button
    }
}
