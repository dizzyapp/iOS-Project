//
//  ConversationsVC.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class ConversationsVC: ViewController {

    let viewModel: ConversationsViewModelType
    
    init(viewModel: ConversationsViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.view.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
