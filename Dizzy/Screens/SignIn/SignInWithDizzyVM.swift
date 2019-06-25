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
    func navigateToHomeScreen()
}

protocol SignInWithDizzyVMDelegate: class {
    func validationFailed(inputValidation: InputValidationResult)
    func userSignedInSuccesfully(user: DizzyUser)
    func userSignedInFailed(error: SignInWebserviceError)
}

class SignInWithDizzyVM: SignInWithDizzyVMType {
    
    weak var navigationDelegate: SignInWithDizzyVMNavigationDelegate?
    weak var delegate: SignInWithDizzyVMDelegate?
    
    var signInInteractor: SignInInteractorType
    let inputValidator: InputValidator
    
    init(signInInteractor: SignInInteractorType, inputValidator: InputValidator) {
        self.signInInteractor = signInInteractor
        self.inputValidator = inputValidator
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
        self.navigationDelegate?.navigateToHomeScreen()
    }
}

extension SignInWithDizzyVM: SignInInteractorDelegate {
    func userSignedInSuccesfully(user: DizzyUser) {
        self.delegate?.userSignedInSuccesfully(user: user)
        self.navigationDelegate?.navigateToHomeScreen()
    }
    
    func userSignedInFailed(error: SignInWebserviceError) {
        self.delegate?.userSignedInFailed(error: error)
    }
}
