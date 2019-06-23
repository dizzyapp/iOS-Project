//
//  LoginVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit

protocol LoginVMType {
    func closeButtonPressed()
    func signUpButtonPressed()
    func loginWithDizzyButtonPressed()
    func loginWithFacebookButtonPressed(presentedVC: UIViewController)
    func appInfoButtonPressed(type: AppInfoType)
    func enterAsAdminButtonPressed()
    
    var navigationDelegate: LoginVMNavigationDelegate? { get set }
    func isUserLoggedIn() -> Bool
}

protocol LoginVMNavigationDelegate: class {
    func navigateToSignUpScreen()
    func navigateToHomeScreen()
    func navigateToSignInScreen()
    func navigateToAppInfoScreen(type: AppInfoType)
    func navigateToAdminScreen()
}

class LoginVM: LoginVMType {
    
    weak var navigationDelegate: LoginVMNavigationDelegate?
    
    var signInInteractor: SignInInteractorType
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
    
    func loginWithFacebookButtonPressed(presentedVC: UIViewController) {
        self.signInInteractor.delegate = self
        self.signInInteractor.signInWithFacebook(presentedVC: presentedVC)
    }
    
    func appInfoButtonPressed(type: AppInfoType) {
        self.navigationDelegate?.navigateToAppInfoScreen(type: type)
    }
    
    func enterAsAdminButtonPressed() {
        self.navigationDelegate?.navigateToAdminScreen()
    }
    
    func isUserLoggedIn() -> Bool {
        return AccessToken.current?.tokenString != nil || Auth.auth().currentUser != nil
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
