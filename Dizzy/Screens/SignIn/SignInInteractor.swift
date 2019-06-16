//
//  SignInInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignInInteractorDelegate: class {
    func userSignedInSuccesfully(user: DizzyUser)
    func userSignedInFailed(error: Error)
}

protocol SignInInteractorType {
    func signInWithDizzy(_ loginCredentialsDetails: LoginCredentialsDetails)
}

class SignInInteractor: SignInInteractorType {

    weak var delegate: SignInInteractorDelegate?
    let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func signInWithDizzy(_ loginCredentialsDetails: LoginCredentialsDetails) {
        let signInResource = Resource<DizzyUser, LoginCredentialsDetails>(path: "signInWithDizzy").withGet()
        webResourcesDispatcher.load(signInResource) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.userSignedInFailed(error: error!)
            case .success(let user):
                self?.delegate?.userSignedInSuccesfully(user: user)
            }
        }
    }
}
