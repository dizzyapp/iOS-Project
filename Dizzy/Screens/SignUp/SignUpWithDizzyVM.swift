//
//  signUpWithDizzyVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpWithDizzyVMType {
    func onSignupPressed(_ loginCredentialsDetails: LoginCredentialsDetails)
    func closeButtonPressed()
    var navigationDelegate: SignUpWithDizzyVMNavigationDelegate? { get set }
    var validationCompletion: ((InputValidationResult) -> Void)? { get set }
}

protocol SignUpWithDizzyVMNavigationDelegate: class {
    func navigateToHomeScreen()
}

class SignUpWithDizzyVM: SignUpWithDizzyVMType {
    
    weak var navigationDelegate: SignUpWithDizzyVMNavigationDelegate?
    var validationCompletion: ((InputValidationResult) -> Void)?

    let userNameMinimumLength = 2
    let emailMinimumLength = 7
    let passwordMinimumLength = 6
    
    let signupInteractor: SignUpInteractorType
    init(signupInteractor: SignUpInteractorType) {
        self.signupInteractor = signupInteractor
    }
    
    func onSignupPressed(_ loginCredentialsDetails: LoginCredentialsDetails) {
        let inputValidation: InputValidationResult = self.checkInput(loginCredentialsDetails: loginCredentialsDetails)
        if inputValidation == .success {
            signupInteractor.signUpWithDizzy(loginCredentialsDetails)
        } else {
            validationCompletion?(inputValidation)
        }
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    private func checkInput(loginCredentialsDetails: LoginCredentialsDetails) -> InputValidationResult {

        if loginCredentialsDetails.email.isEmpty && loginCredentialsDetails.password.isEmpty {
            return .missingDetails
        }
        
        if !loginCredentialsDetails.fullName.isEmpty && loginCredentialsDetails.fullName.count < userNameMinimumLength {
            return .fullNameTooShort
        }
        
        if loginCredentialsDetails.email.count < emailMinimumLength || !loginCredentialsDetails.email.isEmail {
            var validationResult: InputValidationResult
            
            if loginCredentialsDetails.email.count < emailMinimumLength {
                validationResult = .emailAddressTooShort
            } else {
                validationResult = .wrongEmail
            }
            
            return validationResult
        }
        
        if loginCredentialsDetails.password.count < passwordMinimumLength || loginCredentialsDetails.repeatPassword.count < passwordMinimumLength {
            return .passwordTooShort
        }
        
        if loginCredentialsDetails.password != loginCredentialsDetails.repeatPassword {
            return .passwordsNotEqual
        }
        
        return .success
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
