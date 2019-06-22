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
}

class SignUpWithDizzyVM: SignUpWithDizzyVMType {
    
    weak var navigationDelegate: SignUpWithDizzyVMNavigationDelegate?
    var delegate: SignUpWithDizzyVMDelegate?

    let signupInteractor: SignUpInteractorType
    let inputValidator: InputValidator
    
    init(signupInteractor: SignUpInteractorType, inputValidator: InputValidator) {
        self.signupInteractor = signupInteractor
        self.inputValidator = inputValidator
    }
    
    func onSignupPressed(_ signUpDetails: SignUpDetails) {
        let inputValidation: InputValidationResult = self.inputValidator.validateSignUpDetails(signUpDetails)
        if inputValidation == .success {
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
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    func userSignedUpFailed(error: Error) {
        print("Failed to signup")
    }
}
