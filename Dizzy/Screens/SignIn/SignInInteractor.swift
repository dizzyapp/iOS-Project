//
//  SignInInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignInInteractorDelegate: class {
    func userSignedInSuccesfully(_ user: DizzyUser)
    func userSignedInFailed(error: SignInWebserviceError)
}

protocol SignInInteractorType {
    func signInWithDizzy(_ signInDetails: SignInDetails)
    func signInWithFacebook(presentedVC: UIViewController)
    
    var delegate: SignInInteractorDelegate? { get set }
}

class SignInInteractor: SignInInteractorType {

    weak var delegate: SignInInteractorDelegate?
    let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func signInWithDizzy(_ signInDetails: SignInDetails) {
        
        let signInResource = Resource<DizzyUser, SignInDetails>(path: "signInWithDizzy").withPost(signInDetails)
        webResourcesDispatcher.load(signInResource) { [weak self] result in
            switch result {
            case .failure:
                self?.delegate?.userSignedInFailed(error: SignInWebserviceError.userNotExist)
            case .success(let user):
                self?.delegate?.userSignedInSuccesfully(user)
            }
        }
    }
    
    func signInWithFacebook(presentedVC: UIViewController) {
        
        let signInResource = Resource<DizzyUser, SignInDetails>(path: "signInWithFacebook").withPresentedVC(presentedVC)
        webResourcesDispatcher.load(signInResource) { [weak self] result in
            switch result {
            case .failure:
                self?.delegate?.userSignedInFailed(error: SignInWebserviceError.userNotExist)
            case .success(let user):
                self?.delegate?.userSignedInSuccesfully(user)
            }
        }
    }
}
