//
//  TabItem.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

struct TabItem {
    var rootController: UIViewController
    var icon: UIImage?
    var iconSelected: UIImage?
    var title: String?
    
    init(rootController: UIViewController, icon: UIImage? = nil, iconSelected: UIImage? = nil, title: String? = nil) {
        self.rootController = rootController
        self.icon = icon
        self.title = title
        self.iconSelected = iconSelected
    }
}
