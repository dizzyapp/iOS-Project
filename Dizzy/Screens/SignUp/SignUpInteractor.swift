//
//  SignUpInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpInteractorDelegate: class {
    func userSignedUpSuccesfully(user: DizzyUser)
    func userSignedUpFailed(error: Error)
}

protocol SignUpInteractorType {
    func signUpWithDizzy(_ signUpDetails: SignUpDetails)
}

class SignUpInteractor: SignUpInteractorType {

    weak var delegate: SignUpInteractorDelegate?
    let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func signUpWithDizzy(_ signUpDetails: SignUpDetails) {
        let signUpResource = Resource<DizzyUser, SignUpDetails>(path: "signupWithDizzy").withPost(signUpDetails)
        webResourcesDispatcher.load(signUpResource) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.userSignedUpFailed(error: error!)
            case .success(let user):
                self?.saveUserOnRemote(user)
            }
        }
    }
    
    private func saveUserOnRemote(_ user: DizzyUser) {
        let saveUserResource = Resource<String, DizzyUser>(path: "users/\(user.id)").withPost(user)
        webResourcesDispatcher.load(saveUserResource) { (_) in
            self.delegate?.userSignedUpSuccesfully(user: user)
        }
    }
}
