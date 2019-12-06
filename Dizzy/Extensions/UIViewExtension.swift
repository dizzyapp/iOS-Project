//
//  UIViewExtension.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            self.addSubview(subview)
        }
    }
    
    func setBorder(borderColor: UIColor, cornerRadius: CGFloat = 16) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1.0
        layer.borderColor = borderColor.cgColor
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
