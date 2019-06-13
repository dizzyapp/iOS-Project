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
}

class SignUpWithDizzyVM: SignUpWithDizzyVMType {
    
    let signupInteractor: SignUpInteractorType
    init(signupInteractor: SignUpInteractorType) {
        self.signupInteractor = signupInteractor
    }
    
    func onSignupPressed(_ signupDetails: SignupDetails) {
        signupInteractor.signUpWithDizzy(signupDetails)
    }
}
