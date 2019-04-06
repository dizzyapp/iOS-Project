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
}
