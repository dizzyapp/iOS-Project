//
//  signUpWithDizzyVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class SignUpWithDizzyVC: UIViewController, KeyboardDismissing, LoadingContainer, PopupPresenter {
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    var signUpDetailsView = SignUpDetailsView()
    var errorLabel = UILabel()
    
    var viewModel: SignUpWithDizzyVMType

    init(viewModel: SignUpWithDizzyVMType) {
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
        self.view.addSubview(signUpDetailsView)
        
        signUpDetailsView.snp.makeConstraints { signUpDetailsView in
            signUpDetailsView.top.equalTo(view.snp.topMargin).offset(Metrics.padding)
            signUpDetailsView.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .clear
        setupNavigationView()
        setupSignUpDetailsView()
    }
    
    private func setupNavigationView() {
        self.navigationItem.title = "".localized
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.backArrowIcon(), style: .done, target: self, action: #selector(backButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.downArrowIcon(), style: .done, target: self, action: #selector(closeButtonClicked))
    }
    
    private func setupSignUpDetailsView() {
        signUpDetailsView.delegate = self
    }

    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeButtonClicked() {
        self.viewModel.closeButtonPressed()
    }
}

extension SignUpWithDizzyVC: SignUpDetailsViewDelegate {
    func onSignupPressed(_ signUpDetails: SignUpDetails) {
        self.view.endEditing(true)
        self.showSpinner()
        viewModel.onSignupPressed(signUpDetails)
    }
}

extension SignUpWithDizzyVC: SignUpWithDizzyVMDelegate {
    func validationFailed(inputValidation: InputValidationResult) {
        self.hideSpinner()
        let action = Action(title: "Ok".localized)
        showPopup(with: "Validation Error".localized, message: inputValidation.rawValue, actions: [action])
    }
    
    func userSignedUpSuccesfully(user: DizzyUser) {
        self.hideSpinner()
    }
    
    func userSignedUpFailed(error: Error) {
        self.hideSpinner()
        let action = Action(title: "Ok".localized)
       showPopup(with: "Error".localized, message: error.localizedDescription, actions: [action])
    }
}
