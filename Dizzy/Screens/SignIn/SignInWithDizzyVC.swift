//
//  SignInWithDizzyVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class SignInWithDizzyVC: UIViewController {
    var signInDetailsView = SignInDetailsView()
    var viewModel: SignInWithDizzyVMType

    init(viewModel: SignInWithDizzyVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = "Sign In".localized

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.backArrowIcon().withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.downArrowIcon().withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeButtonClicked))
        
        self.hideKeyboardWhenTappedAround()
        
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        self.view.addSubview(signInDetailsView)
        
        signInDetailsView.snp.makeConstraints { signInDetailsView in
            signInDetailsView.top.equalTo(view.snp.topMargin).offset(Metrics.padding)
            signInDetailsView.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .clear
        setupSignInDetailsView()
        setupViewModel()
    }
    
    private func setupSignInDetailsView() {
        signInDetailsView.delegate = self
    }
    
    private func setupViewModel() {
        self.viewModel.validationCompletion = { [weak self] (inputValidation) in
            self?.signInDetailsView.showErrorMessage(inputValidation.localizedDescription)
        }
    }
    
    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeButtonClicked() {
        self.viewModel.closeButtonPressed()
    }
}

extension SignInWithDizzyVC: SignInDetailsViewDelegate {
    func onSignInPressed(_ loginCredentialsDetails: LoginCredentialsDetails) {
        viewModel.onSignInPressed(loginCredentialsDetails)
    }
}
