//
//  Fonts.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import UIKit

enum Weight {
    case regular
    case bold
}

struct Fonts {
    
    static func regular(size: CGFloat) -> UIFont {
        return Family.regular(size: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return Family.bold(size: size)
    }
    
    static func i3(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 25)
    }
    
    static func i2(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 24)
    }
    
    static func i1(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 23)
    }
    
    static func h1(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 22)
    }
    static func h2(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 21)
    }
    static func h3(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 20)
    }
    static func h4(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 19)
    }
    static func h5(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 18)
    }
    static func h6(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 17)
    }
    static func h7(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 16)
    }
    static func h8(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 15)
    }
    static func h9(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 14)
    }
    static func h10(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 13)
    }
    static func h11(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 12)
    }
    static func h12(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 11)
    }
    static func h13(weight: Weight = .regular) -> UIFont {
        return Family.familyType(weight: weight, size: 10)
    }
}

let mainAppFont = "Avenir"
let mainAppFontBold = "Avenir-Heavy"

struct Family {
    static func regular(size: CGFloat) -> UIFont {
        return UIFont.init(name: mainAppFont, size: size)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont.init(name: mainAppFontBold, size: size)!
    }
    
    static func familyType(weight: Weight, size: CGFloat) -> UIFont {
        switch weight {
        case .regular:
            return Family.regular(size: size)
        case .bold:
            return Family.bold(size: size)
        }
    }
}
