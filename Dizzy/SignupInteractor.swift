//
//  SignupInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 09/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignupInteractorType {
    func signupWithDizzy(_ signupDetails: SignupDetails)
}

class SignupInteractor: SignupInteractorType {
    
    let webResourceDispatcher: WebServiceDispatcher
    
    init(webResourcesDispatcher: WebServiceDispatcher) {
        self.webResourceDispatcher = webResourcesDispatcher
    }
    
    func signupWithDizzy(_ signupDetails: SignupDetails) {
        let signupWebResource = Resource< String, SignupDetails>(path: "loginWithDizzy").withPost(signupDetails)
        webResourceDispatcher.load(signupWebResource) { _ in
            
        }
    }

}
