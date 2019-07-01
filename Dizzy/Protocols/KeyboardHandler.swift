//
//  KeyboardHandler.swift
//  Dizzy
//
//  Created by stas berkman on 22/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

public protocol KeyboardDismissing {
    func hideKeyboardWhenTappedAround(cancelTouches: Bool, callback: (_ tap: UITapGestureRecognizer) -> Void)
}

extension KeyboardDismissing where Self: UIViewController {
    func hideKeyboardWhenTappedAround(cancelTouches: Bool, callback: (_ tap: UITapGestureRecognizer) -> Void) {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        tap.cancelsTouchesInView = cancelTouches
        self.view.addGestureRecognizer(tap)
        callback(tap)
    }
}
