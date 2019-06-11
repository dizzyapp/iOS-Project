//
//  Colors.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 20/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) {
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)
    }
}

extension UIColor {
    static var primeryPurple: UIColor {
        return UIColor(red: 122, green: 105, blue: 177)
    }
}
