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
    func navigateToSignInWithDizzyScreen()
    func navigateToSignInWithFacebook()
    func navigateToAppInfoScreen(type: AppInfoType)
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
        self.navigationDelegate?.navigateToSignInWithFacebook()
    }
    
    func appInfoButtonPressed(type: AppInfoType) {
        self.navigationDelegate?.navigateToAppInfoScreen(type: type)
    }
    
    func enterAsAdminButtonPressed() {
        self.navigationDelegate?.navigateToAdminScreen()
    }
}
