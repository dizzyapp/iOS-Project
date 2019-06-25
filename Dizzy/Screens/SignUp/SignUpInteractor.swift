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
    func userSignedUpFailed(error: SignupWebServiceError)
}

protocol SignUpInteractorType {
    func signUpWithDizzy(_ signUpDetails: SignUpDetails)
    
    var delegate: SignUpInteractorDelegate? { get set }
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
            case .failure( _):
                self?.delegate?.userSignedUpFailed(error: SignupWebServiceError.userCreationFailed)
            case .success(let user):
                self?.saveUserOnRemote(user)
            }
        }
    }
    
    private func saveUserOnRemote(_ user: DizzyUser) {
        let saveUserResource = Resource<String, DizzyUser>(path: "users/\(user.id)").withPost(user)
        webResourcesDispatcher.load(saveUserResource) { [weak self] result in            
            switch result {
            case .failure(let error):
                if error != nil {
                    self?.delegate?.userSignedUpFailed(error: SignupWebServiceError.userCreationFailed)
                } else {
                    self?.delegate?.userSignedUpSuccesfully(user: user)
                }
            case .success( _): break
            }
        }
    }
}
