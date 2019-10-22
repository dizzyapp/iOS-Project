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
    func logoutButtonPressed()
    func loginWithDizzyButtonPressed()
    func loginWithFacebookButtonPressed(presentedVC: UIViewController)
    func appInfoButtonPressed(type: AppInfoType)
    func enterAsAdminButtonPressed()
    
    var navigationDelegate: LoginVMNavigationDelegate? { get set }
    var delegate: LoginVMDelegate? { get set }

    func isUserLoggedIn() -> Bool
}

protocol LoginVMNavigationDelegate: class {
    func navigateToSignUpScreen()
    func userLoggedIn(user: DizzyUser)
    func navigateToSignInScreen()
    func navigateToAppInfoScreen(type: AppInfoType)
    func navigateToAdminScreen()
    func closePressed()
}

protocol LoginVMDelegate: class {
    func userSignedInSuccesfully()
    func userSignedInFailed(error: SignInWebserviceError)
    func userLoggedoutSuccessfully()
    func userLoggedoutFailed(error: Error)
}

class LoginVM: LoginVMType {
    
    weak var navigationDelegate: LoginVMNavigationDelegate?
    weak var delegate: LoginVMDelegate?

    var signInInteractor: SignInInteractorType
    var logoutInteractor: LogoutInteractorType
    let userDefaults: MyUserDefaultsType
    let usersInteractor: UsersInteracteorType
    var user: DizzyUser
    
    init(signInInteractor: SignInInteractorType, logoutInteractor: LogoutInteractorType, userDefaults: MyUserDefaultsType, usersInteractor: UsersInteracteorType, user: DizzyUser) {
        self.signInInteractor = signInInteractor
        self.logoutInteractor = logoutInteractor
        self.userDefaults = userDefaults
        self.usersInteractor = usersInteractor
        self.user = user
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.closePressed()
    }
    
    func logoutButtonPressed() {
        self.logoutInteractor.delegate = self
        self.logoutInteractor.logout()
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
    
    private func isLoggedInViaFacebook() -> Bool {
        return AccessToken.current?.tokenString != nil
    }
    
    private func isLoggedInViaDizzy() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func isUserLoggedIn() -> Bool {
        return self.user.role != .guest
    }
}

extension LoginVM: SignInInteractorDelegate {
    func userSignedInSuccesfully(_ userId: String) {
        
        usersInteractor.getUserForId(userId: userId) { [weak self] user in
            guard let user = user else {
                print("error getting user for id: \(userId)")
                return
            }
            
            self?.userDefaults.saveLoggedInUserId(userId: user.id)
            self?.delegate?.userSignedInSuccesfully()
            self?.navigationDelegate?.userLoggedIn(user: user)
        }
    }
    
    func userSignedInFailed(error: SignInWebserviceError) {
        self.delegate?.userSignedInFailed(error: error)
    }
}

extension LoginVM: LogoutInteractorDelegate {
    func userLoggedoutSuccessfully() {
        userDefaults.clearLoggedInUserId()
        self.delegate?.userLoggedoutSuccessfully()
    }
    
    func userLoggedoutFailed(error: Error) {
        self.delegate?.userLoggedoutFailed(error: error)
    }
}
