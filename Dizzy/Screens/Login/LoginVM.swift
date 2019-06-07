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
    func aboutButtonPressed()
    func termsOfUseButtonPressed()
    func privacyPolicyButtonPressed()
    func contactUsButtonPressed()
    func enterAsAdminButtonPressed()
    
    var navigationDelegate: LoginVMNavigationDelegate? { get set }
}

protocol LoginVMNavigationDelegate: class {
    func navigateToSignUpScreen()
    func navigateToHomeScreen()
    func navigateToSignInWithDizzyScreen()
    func navigateToAboutScreen()
    func navigateToTermsOfUseScreen()
    func navigateToPrivacyPolicyScreen()
    func navigateToContactUsScreen()
    func navigateToAdminScreen()
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
        self.navigationDelegate?.navigateToSignInWithDizzyScreen()
    }
    
    func loginWithFacebookButtonPressed() {
        
    }
    
    func aboutButtonPressed() {
        self.navigationDelegate?.navigateToAboutScreen()
    }
    
    func termsOfUseButtonPressed() {
        self.navigationDelegate?.navigateToTermsOfUseScreen()
    }
    
    func privacyPolicyButtonPressed() {
        self.navigationDelegate?.navigateToPrivacyPolicyScreen()
    }
    
    func contactUsButtonPressed() {
        self.navigationDelegate?.navigateToContactUsScreen()
    }
    
    func enterAsAdminButtonPressed() {
        self.navigationDelegate?.navigateToAdminScreen()
    }
}
