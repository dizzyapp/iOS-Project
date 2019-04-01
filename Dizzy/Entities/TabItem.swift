//
//  TabItem.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

struct TabItem {
    var rootController: UINavigationController
    var icon: UIImage?
    var title: String?
    
    init(rootController: UINavigationController, icon: UIImage? = nil, title: String? = nil) {
        self.rootController = rootController
        self.icon = icon
        self.title = title
    }
}
