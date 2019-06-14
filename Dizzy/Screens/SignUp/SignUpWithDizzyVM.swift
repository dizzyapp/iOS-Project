//
//  signUpWithDizzyVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpWithDizzyVMType {
    func onSignupPressed(_ signupDetails: SignupDetails)
    func closeButtonPressed()
    var navigationDelegate: SignUpWithDizzyVMNavigationDelegate? { get set }
}

protocol SignUpWithDizzyVMNavigationDelegate: class {
    func navigateToHomeScreen()
}

class SignUpWithDizzyVM: SignUpWithDizzyVMType {
    
    weak var navigationDelegate: SignUpWithDizzyVMNavigationDelegate?

    let signupInteractor: SignUpInteractorType
    init(signupInteractor: SignUpInteractorType) {
        self.signupInteractor = signupInteractor
    }
    
    func onSignupPressed(_ signupDetails: SignupDetails) {
        signupInteractor.signUpWithDizzy(signupDetails)
    }
    
    func closeButtonPressed() {
        self.navigationDelegate?.navigateToHomeScreen()
    }
}
