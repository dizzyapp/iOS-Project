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
    let backButton = UIButton(type: .system)
    var signUpDetailsView = SignUpDetailsView()
    let viewModel: SignUpWithDizzyVMType

    init(viewModel: SignUpWithDizzyVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        layoutViews()
        setupBackButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        self.view.addSubviews([signUpDetailsView, backButton])
        
        backButton.snp.makeConstraints { backButton in
            backButton.top.equalTo(view.snp.topMargin).offset(Metrics.padding)
            backButton.trailing.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
        
        signUpDetailsView.snp.makeConstraints { signUpDetailsView in
            signUpDetailsView.top.equalTo(backButton.snp.bottom).offset(Metrics.padding)
            signUpDetailsView.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupBackButton() {
        backButton.setTitle("back", for: .normal)
    }
}
