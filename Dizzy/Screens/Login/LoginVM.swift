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
    func loginWithFacebookButtonPressed(viewController: UIViewController)
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

class LoginVM: LoginVMType {
    
    weak var navigationDelegate: LoginVMNavigationDelegate?
    
    let signInInteractor: SignInInteractorType
    init(signInInteractor: SignInInteractorType) {
        self.signInInteractor = signInInteractor
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
    
    func loginWithFacebookButtonPressed(viewController: UIViewController) {
        self.signInInteractor.signInWithFacebook(presentOnViewController: viewController)
    }
    
    func appInfoButtonPressed(type: AppInfoType) {
        self.navigationDelegate?.navigateToAppInfoScreen(type: type)
    }
    
    func enterAsAdminButtonPressed() {
        self.navigationDelegate?.navigateToAdminScreen()
    }
}

extension LoginVM: SignInInteractorDelegate {
    func userSignedInSuccesfully(user: DizzyUser) {
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    func userSignedInFailed(error: Error) {
        print("Failed to signIn")
    }
}
