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
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Metrics.mediumPadding, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Metrics.mediumPadding, height: 0))
        rightView = rightPaddingView
        rightViewMode = .always
        return self
    }
}
