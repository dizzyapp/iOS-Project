//
//  LoginVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol LoginVMType {
    func closeButtonPressed()
    func signUpButtonPressed()
    func loginWithDizzyButtonPressed()
    func loginWithFacebookButtonPressed()
    func appInfoButtonPressed(type: AppInfoType)
    func enterAsAdminButtonPressed()
    
    var navigationDelegate: LoginVMNavigationDelegate? { get set }
}

protocol LoginVMNavigationDelegate: class {
    func navigateToSignUpScreen()
    func navigateToHomeScreen()
    func navigateToSignInScreen()
    func navigateToSignInWithFacebook()
    func navigateToAppInfoScreen(type: AppInfoType)
    func navigateToAdminScreen()
}

enum InputValidationResult {
    case fullNameTooShort
    case emailAddressTooShort
    case wrongEmail
    case passwordTooShort
    case passwordsNotEqual
    case missingDetails
    case success
    
    var localizedDescription: String {
        switch self {
        case .fullNameTooShort:
            return "Full name is too short, please enter at least 2 characters".localized
        case .emailAddressTooShort:
            return "Email address is too short, please enter at least 7 characters".localized
        case .wrongEmail:
            return "Email address is not correct, please enter a valid email address".localized
        case .passwordTooShort:
            return "Password is too short, please enter at least 6 characters".localized
        case .passwordsNotEqual:
            return "Passwords are not equal, please try again!"
        case .missingDetails:
            return "Please fill all the fields".localized
        case .success:
            return "Succeed".localized
        }
    }
}

class LoginVM: LoginVMType {
    
    weak var navigationDelegate: LoginVMNavigationDelegate?
    
    init() {
        
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    func signUpButtonPressed() {
        self.navigationDelegate?.navigateToSignUpScreen()
    }
    
    func loginWithDizzyButtonPressed() {
        self.navigationDelegate?.navigateToSignInScreen()
    }
    
    func loginWithFacebookButtonPressed() {
        self.navigationDelegate?.navigateToSignInWithFacebook()
    }
    
    func appInfoButtonPressed(type: AppInfoType) {
        self.navigationDelegate?.navigateToAppInfoScreen(type: type)
    }
    
    func enterAsAdminButtonPressed() {
        self.navigationDelegate?.navigateToAdminScreen()
    }
}
