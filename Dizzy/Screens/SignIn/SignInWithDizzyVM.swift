//
//  signInWithDizzyVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignInWithDizzyVMType {
    func onSignInPressed(_ signInDetails: SignInDetails)
    func closeButtonPressed()
    var navigationDelegate: SignInWithDizzyVMNavigationDelegate? { get set }
    var delegate: SignInWithDizzyVMDelegate? { get set }
}

protocol SignInWithDizzyVMNavigationDelegate: class {
    func userLoggedIn(user: DizzyUser)
    func closePressed()
}

protocol SignInWithDizzyVMDelegate: class {
    func validationFailed(inputValidation: InputValidationResult)
    func userSignedInSuccesfully()
    func userSignedInFailed(error: SignInWebserviceError)
}

class SignInWithDizzyVM: SignInWithDizzyVMType {
    
    weak var navigationDelegate: SignInWithDizzyVMNavigationDelegate?
    weak var delegate: SignInWithDizzyVMDelegate?
    
    var signInInteractor: SignInInteractorType
    let usersInteractor: UsersInteracteorType
    let userDefaults: MyUserDefaultsType
    let inputValidator: InputValidator
    
    init(signInInteractor: SignInInteractorType, inputValidator: InputValidator, usersInteractor: UsersInteracteorType, userDefaults: MyUserDefaultsType) {
        self.signInInteractor = signInInteractor
        self.inputValidator = inputValidator
        self.usersInteractor = usersInteractor
        self.userDefaults = userDefaults
    }
    
    func onSignInPressed(_ signInDetails: SignInDetails) {
        let inputValidation: InputValidationResult = self.inputValidator.validateSignInDetails(signInDetails)
        if inputValidation == .success {
            signInInteractor.delegate = self
            signInInteractor.signInWithDizzy(signInDetails)
        } else {
            delegate?.validationFailed(inputValidation: inputValidation)
        }
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.closePressed()
    }
}

extension SignInWithDizzyVM: SignInInteractorDelegate {
    func userSignedInSuccesfully(_ userId: String) {
        usersInteractor.getUserForId(userId: userId) { [weak self] user in
            guard let user = user else {
                print("could not get user for id: \(userId)")
                return
            }
            self?.userDefaults.saveLoggedInUserId(userId: user.id)
            self?.navigationDelegate?.userLoggedIn(user: user)
            self?.delegate?.userSignedInSuccesfully()
        }
    }
    
    func userSignedInFailed(error: SignInWebserviceError) {
        self.delegate?.userSignedInFailed(error: error)
    }
}
