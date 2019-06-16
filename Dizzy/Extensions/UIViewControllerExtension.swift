//
//  UIViewControllerExtension.swift
//  Dizzy
//
//  Created by stas berkman on 16/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    ///
    /// - Parameter cancelTouches: Cancel touches outside the keyboard frame
    open func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        self.view.addGestureRecognizer(tap)
    }
    
    /// Dismisses keyboard
    @objc open func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
