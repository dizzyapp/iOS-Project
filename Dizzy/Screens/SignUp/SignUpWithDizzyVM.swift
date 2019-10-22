//
//  signUpWithDizzyVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpWithDizzyVMType {
    func onSignupPressed(_ signUpDetails: SignUpDetails)
    func closeButtonPressed()
    var navigationDelegate: SignUpWithDizzyVMNavigationDelegate? { get set }
    var delegate: SignUpWithDizzyVMDelegate? { get set }
}

protocol SignUpWithDizzyVMNavigationDelegate: class {
    func closePressed()
    func userLoggedIn(user: DizzyUser)
}

protocol SignUpWithDizzyVMDelegate: class {
    func validationFailed(inputValidation: InputValidationResult)
    func userSignedUpSuccesfully(user: DizzyUser)
    func userSignedUpFailed(error: Error)
}

class SignUpWithDizzyVM: SignUpWithDizzyVMType {
    
    weak var navigationDelegate: SignUpWithDizzyVMNavigationDelegate?
    weak var delegate: SignUpWithDizzyVMDelegate?

    var signupInteractor: SignUpInteractorType
    let userDefaults: MyUserDefaultsType
    let usersInteractor: UsersInteracteorType
    let inputValidator: InputValidator
    
    init(signupInteractor: SignUpInteractorType, inputValidator: InputValidator, usersInteractor: UsersInteracteorType, userDefaults: MyUserDefaultsType) {
        self.signupInteractor = signupInteractor
        self.inputValidator = inputValidator
        self.usersInteractor = usersInteractor
        self.userDefaults = userDefaults
    }
    
    func onSignupPressed(_ signUpDetails: SignUpDetails) {
        let inputValidation: InputValidationResult = self.inputValidator.validateSignUpDetails(signUpDetails)
        if inputValidation == .success {
            signupInteractor.delegate = self
            signupInteractor.signUpWithDizzy(signUpDetails)
        } else {
            self.delegate?.validationFailed(inputValidation: inputValidation)
        }
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.closePressed()
    }
}

extension SignUpWithDizzyVM: SignUpInteractorDelegate {
    func userSignedUpSuccesfully(user: DizzyUser) {
        userDefaults.saveLoggedInUserId(userId: user.id)
        usersInteractor.saveUserOnRemote(user)
        self.delegate?.userSignedUpSuccesfully(user: user)
        self.navigationDelegate?.userLoggedIn(user: user)
    }
    
    func userSignedUpFailed(error: Error) {
        self.delegate?.userSignedUpFailed(error: error)
    }
}
