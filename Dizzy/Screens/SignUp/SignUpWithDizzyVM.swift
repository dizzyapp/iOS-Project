//
//  signUpWithDizzyVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpWithDizzyVMType {
    func onSignupPressed(_ signUpDetails: SignUpDetails)
    func closeButtonPressed()
    var navigationDelegate: SignUpWithDizzyVMNavigationDelegate? { get set }
    var delegate: SignUpWithDizzyVMDelegate? { get set }
}

protocol SignUpWithDizzyVMNavigationDelegate: class {
    func navigateToHomeScreen()
}

protocol SignUpWithDizzyVMDelegate: class {
    func validationFailed(inputValidation: InputValidationResult)
    func userSignedUpSuccesfully(user: DizzyUser)
    func userSignedUpFailed(error: Error)
}

class SignUpWithDizzyVM: SignUpWithDizzyVMType {
    
    weak var navigationDelegate: SignUpWithDizzyVMNavigationDelegate?
    weak var delegate: SignUpWithDizzyVMDelegate?

    var signupInteractor: SignUpInteractorType
    let inputValidator: InputValidator
    
    init(signupInteractor: SignUpInteractorType, inputValidator: InputValidator) {
        self.signupInteractor = signupInteractor
        self.inputValidator = inputValidator
    }
    
    func onSignupPressed(_ signUpDetails: SignUpDetails) {
        let inputValidation: InputValidationResult = self.inputValidator.validateSignUpDetails(signUpDetails)
        if inputValidation == .success {
            signupInteractor.delegate = self
            signupInteractor.signUpWithDizzy(signUpDetails)
        } else {
            self.delegate?.validationFailed(inputValidation: inputValidation)
        }
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.navigateToHomeScreen()
    }
}

extension SignUpWithDizzyVM: SignUpInteractorDelegate {
    func userSignedUpSuccesfully(user: DizzyUser) {
        self.delegate?.userSignedUpSuccesfully(user: user)
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    func userSignedUpFailed(error: Error) {
        self.delegate?.userSignedUpFailed(error: error)
    }
}
