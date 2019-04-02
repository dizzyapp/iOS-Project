//
//  DiscoveryVC.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class DiscoveryVC: ViewController {
    let viewModel: DiscoveryViewModelType
    
    init(viewModel: DiscoveryViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.view.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
