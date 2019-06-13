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
        let signUpResource = Resource<User, SignupDetails>(path: "signupWithDizzy").withPost(signUpDetails)
        webResourcesDispatcher.load(signUpResource) { [weak self] result in
            switch result {
            case .failure(let error):
                return
            case .success(let user):
                self?.saveUserOnRemote(user)
            }
        }
    }
    
    private func saveUserOnRemote(_ user: User) {
        let saveUserResource = Resource<String, User>(path: "users/\(user.id)").withPost(user)
        webResourcesDispatcher.load(saveUserResource) { (response) in
            print(response)
        }
    }
}
