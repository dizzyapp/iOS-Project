//
//  SignInWithDizzyVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class SignInWithDizzyVC: UIViewController, KeyboardDismissing, LoadingContainer {
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    var signInDetailsView = SignInDetailsView()
    var viewModel: SignInWithDizzyVMType

    init(viewModel: SignInWithDizzyVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        
        self.hideKeyboardWhenTappedAround(cancelTouches: false) { (_) in
            self.view.endEditing(true)
        }
        
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
        setupNavigationView()
        setupSignInDetailsView()
    }
    
    private func setupNavigationView() {
        self.navigationItem.title = "Sign In".localized
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.backArrowIcon(), style: .done, target: self, action: #selector(backButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.downArrowIcon(), style: .done, target: self, action: #selector(closeButtonClicked))
    }
    
    private func setupSignInDetailsView() {
        signInDetailsView.delegate = self
    }
    
    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeButtonClicked() {
        self.viewModel.closeButtonPressed()
    }
}

extension SignInWithDizzyVC: SignInDetailsViewDelegate {
    func onSignInPressed(_ signInDetails: SignInDetails) {
        self.showSpinner()
        viewModel.onSignInPressed(signInDetails)
    }
}

extension SignInWithDizzyVC: SignInWithDizzyVMDelegate {
    func validationFailed(inputValidation: InputValidationResult) {
        self.hideSpinner()
        self.signInDetailsView.showErrorMessage(inputValidation.rawValue)
    }
    func userSignedInSuccesfully(user: DizzyUser) {
        self.hideSpinner()
    }
    func userSignedInFailed(error: SignInWebserviceError) {
        self.hideSpinner()
        
    }
}
