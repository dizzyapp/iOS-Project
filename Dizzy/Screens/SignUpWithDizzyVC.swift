//
//  signUpWithDizzyVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class SignUpWithDizzyVC: UIViewController {
    var signUpDetailsView = SignUpDetailsView()
    let viewModel: SignUpWithDizzyVMType

    init(viewModel: SignUpWithDizzyVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        self.view.addSubview(signUpDetailsView)
        signUpDetailsView.snp.makeConstraints { signUpDetailsView in
            signUpDetailsView.top.equalTo(view.snp.topMargin).offset(Metrics.doublePadding)
            signUpDetailsView.leading.trailing.equalToSuperview()
        }
    }

}
