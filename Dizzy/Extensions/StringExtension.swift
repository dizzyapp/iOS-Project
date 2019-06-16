//
//  StringExtension.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 22/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isEmail: Bool {
        let regex: String = "[a-zA-Z0-9.\\-_]{2,32}@[a-zA-Z0-9.\\-_]{2,32}\\.[A-Za-z]{2,4}"
        let regExPredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return regExPredicate.evaluate(with: self)
    }
}
