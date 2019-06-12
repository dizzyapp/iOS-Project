//
//  SignUpInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpInteractorType {
    func signUpWithDizzy(_ signUpDetails: SignupDetails)
}

class SignUpInteractor: SignUpInteractorType {

    let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func signUpWithDizzy(_ signUpDetails: SignupDetails) {
        let signUpResource = Resource<String, SignupDetails>(path: "signupWithDizzy")
        webResourcesDispatcher.load(signUpResource) { (result) in
            print(result)
        }
    }
}
