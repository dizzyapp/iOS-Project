//
//  LoginVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol LoginVMType {
    func onLogin()
    func onSignIn()
    
    var navigationDelegate: LoginVMNavigationDelegate? { get set }
}

protocol LoginVMNavigationDelegate: class {
    func navigateToSignUpScreen()
    func navigateToHomeScreen()
}

class LoginVM: LoginVMType {
    
    weak var navigationDelegate: LoginVMNavigationDelegate?
    
    init() {
        
    }
    
    func onLogin() {
        
    }
    
    func onSignIn() {
        
    }
}
