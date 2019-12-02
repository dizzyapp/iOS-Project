//
//  LabelExtension.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension NSTextAlignment {
    
    static var oppositeNatural: NSTextAlignment {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? left : right
    }
}
