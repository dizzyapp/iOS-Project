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
        addPaddingToMarker()
        return self
    }
    
    func withDarkPurpleRoundedCorners(withPlaceholder placeholder: String) -> UITextField {
        textAlignment = .center
        layer.cornerRadius = 17
        font = Fonts.h10(weight: .bold)
        layer.borderColor = UIColor(red:0.65, green:0.69, blue:0.2, alpha: 1).cgColor
        layer.borderWidth = 1
        textColor = .white
        attributedPlaceholder = NSAttributedString(string: placeholder ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        backgroundColor =  UIColor(red:0.01, green:0, blue:0.2, alpha:1)
        snp.makeConstraints { selfTextField in
            selfTextField.height.equalTo(32)
        }
        return  self
    }
    
    func withTransperentRoundedCorners(borderColor: UIColor, cornerRadius: CGFloat? = nil) -> UITextField {
        layer.cornerRadius = cornerRadius ?? 16
        layer.borderWidth = 1.0
        textColor = UIColor.white
        layer.borderColor = borderColor.cgColor
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Metrics.mediumPadding, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always
        
        return self
    }
    func addPaddingToMarker() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Metrics.mediumPadding, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Metrics.mediumPadding, height: 0))
        rightView = rightPaddingView
        rightViewMode = .always
    }
    
    func loginTextfield(withPlaceholder placeholder: String) -> UITextField {
        background = Images.signUpTextfield()
        borderStyle = .none
        font = Fonts.h10()
        textAlignment = .left
        textColor = .black
        attributedPlaceholder = NSAttributedString(string: placeholder ,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return self
    }
}
