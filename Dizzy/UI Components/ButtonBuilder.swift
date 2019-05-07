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
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16.0
        return button
    }
}
