//
//  TextFieldBuilder.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension UITextField {
    
    var withTransperentRoundedCorners: UITextField {
        layer.cornerRadius = 16
        layer.borderWidth = 1.0
        textAlignment = .center
        textColor = UIColor.white
        layer.borderColor = UIColor.white.cgColor
        return self
    }
}
