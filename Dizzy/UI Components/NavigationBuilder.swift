//
//  NavigationBuilder.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 15/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension UIViewController {
    func embdedInNavigationController() -> UINavigationController {
        let nvc = UINavigationController(rootViewController: self)
        return nvc
    }
}

extension UINavigationController {
    func withTransparentStyle() -> UINavigationController {
        let navBar = self.navigationBar
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        return self
    }
}
