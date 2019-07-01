//
//  InputValidator.swift
//  Dizzy
//
//  Created by stas berkman on 22/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

enum InputValidationResult: String {
    case fullNameTooShort = "Full name is too short, please enter at least 2 characters"
    case emailAddressTooShort = "Email address is too short, please enter at least 7 characters"
    case wrongEmail = "Email address is not correct, please enter a valid email address"
    case passwordTooShort = "Password is too short, please enter at least 6 characters"
    case passwordsNotEqual = "Passwords are not equal, please try again!"
    case missingDetails = "Please fill all the fields"
    case success = "Succeed"
}

class InputValidator: NSObject {
    
    let userNameMinimumLength = 2
    let emailMinimumLength = 7
    let passwordMinimumLength = 6
    
    func validateSignUpDetails(_ signUpDetails: SignUpDetails) -> InputValidationResult {
        
        let fullNameValidation: InputValidationResult = self.validateFullNameField(signUpDetails.fullName)
        if fullNameValidation != .success {
            return fullNameValidation
        }
        
        let emailValidation: InputValidationResult = self.validateEmailField(signUpDetails.email)
        if emailValidation != .success {
            return emailValidation
        }
        let passwordValidation: InputValidationResult = self.validatePasswordField(signUpDetails.password)
        if passwordValidation != .success {
            return passwordValidation
        }
        
        let repeatPasswordValidation: InputValidationResult = self.validatePasswordField(signUpDetails.repeatPassword)
        if repeatPasswordValidation != .success {
            return repeatPasswordValidation
        }
        
        let passwordEqualityValidation: InputValidationResult = self.validatePasswordEquality(password: signUpDetails.password, repeatPassword: signUpDetails.repeatPassword)
        if passwordEqualityValidation != .success {
            return passwordEqualityValidation
        }
        
        return .success
    }
    
    func validateSignInDetails(_ signInDetails: SignInDetails) -> InputValidationResult {
        let emailValidation: InputValidationResult = self.validateEmailField(signInDetails.email)
        if emailValidation != .success {
            return emailValidation
        }
        let passwordValidation: InputValidationResult = self.validatePasswordField(signInDetails.password)
        if passwordValidation != .success {
            return passwordValidation
        }
        
        return .success
    }
    
    private func validateFullNameField(_ fullName: String) -> InputValidationResult {
        if !fullName.isEmpty && fullName.count < userNameMinimumLength {
            return .fullNameTooShort
        }
        return .success
    }
    
    private func validateEmailField(_ email: String) -> InputValidationResult {
        if email.count < emailMinimumLength || !email.isEmail {
            
            if email.count < emailMinimumLength {
                return .emailAddressTooShort
            } else {
                return .wrongEmail
            }
        }
        
        return .success
    }
    
    private func validatePasswordField(_ password: String) -> InputValidationResult {
        if password.count < passwordMinimumLength {
            return .passwordTooShort
        }
        
        return .success
    }
    
    private func validatePasswordEquality(password: String, repeatPassword: String) -> InputValidationResult {
        if password != repeatPassword {
            return .passwordsNotEqual
        }
        
        return .success
    }
}
