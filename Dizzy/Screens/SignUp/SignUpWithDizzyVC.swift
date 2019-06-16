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
    var errorLabel = UILabel()
    
    var viewModel: SignUpWithDizzyVMType

    init(viewModel: SignUpWithDizzyVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = "Sign Up".localized

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
        self.view.addSubview(signUpDetailsView)
        
        signUpDetailsView.snp.makeConstraints { signUpDetailsView in
            signUpDetailsView.top.equalTo(view.snp.topMargin).offset(Metrics.padding)
            signUpDetailsView.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .clear
        setupSignUpDetailsView()
        setupViewModel()
    }
    
    private func setupSignUpDetailsView() {
        signUpDetailsView.delegate = self
    }
    
    private func setupViewModel() {
        self.viewModel.validationCompletion = { [weak self] (inputValidation) in
            self?.signUpDetailsView.showErrorMessage(inputValidation.localizedDescription)
        }
    }
    
    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeButtonClicked() {
        self.viewModel.closeButtonPressed()
    }
}

extension SignUpWithDizzyVC: SignUpDetailsViewDelegate {
    func onSignupPressed(_ loginCredentialsDetails: LoginCredentialsDetails) {
        viewModel.onSignupPressed(loginCredentialsDetails)
    }
}
