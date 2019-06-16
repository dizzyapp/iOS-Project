//
//  signInWithDizzyVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignInWithDizzyVMType {
    func onSignInPressed(_ loginCredentialsDetails: LoginCredentialsDetails)
    func closeButtonPressed()
    var navigationDelegate: SignInWithDizzyVMNavigationDelegate? { get set }
    var validationCompletion: ((InputValidationResult) -> Void)? { get set }
}

protocol SignInWithDizzyVMNavigationDelegate: class {
    func navigateToHomeScreen()
}

class SignInWithDizzyVM: SignInWithDizzyVMType {
    
    weak var navigationDelegate: SignInWithDizzyVMNavigationDelegate?
    var validationCompletion: ((InputValidationResult) -> Void)?

    let emailMinimumLength = 7
    let passwordMinimumLength = 6
    
    let signInInteractor: SignInInteractorType
    init(signInInteractor: SignInInteractorType) {
        self.signInInteractor = signInInteractor
    }
    
    func onSignInPressed(_ loginCredentialsDetails: LoginCredentialsDetails) {
        let inputValidation: InputValidationResult = self.checkInput(loginCredentialsDetails: loginCredentialsDetails)
        if inputValidation == .success {
            signInInteractor.signInWithDizzy(loginCredentialsDetails)
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
        
        if loginCredentialsDetails.email.count < emailMinimumLength || !loginCredentialsDetails.email.isEmail {
            var validationResult: InputValidationResult
            
            if loginCredentialsDetails.email.count < emailMinimumLength {
                validationResult = .emailAddressTooShort
            } else {
                validationResult = .wrongEmail
            }
            
            return validationResult
        }
        
        if loginCredentialsDetails.password.count < passwordMinimumLength {
            return .passwordTooShort
        }
        
        return .success
    }
}

extension SignInWithDizzyVM: SignInInteractorDelegate {
    func userSignedInSuccesfully(user: DizzyUser) {
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    func userSignedInFailed(error: Error) {
        print("Failed to signIn")
    }
}
