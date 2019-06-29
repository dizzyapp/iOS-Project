//
//  LogoutInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol LogoutInteractorDelegate: class {
    func userLoggedoutSuccessfully()
    func userLoggedoutFailed(error: Error)
}

protocol LogoutInteractorType {
    func logout()

    var delegate: LogoutInteractorDelegate? { get set }
}

class LogoutInteractor: LogoutInteractorType {

    weak var delegate: LogoutInteractorDelegate?
    let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func logout() {
        
        let logoutResource = Resource<String, String>(path: "logout")

        webResourcesDispatcher.load(logoutResource) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.userLoggedoutFailed(error: error)
            case .success:
                self?.delegate?.userLoggedoutSuccessfully()
            }
        }
    }
}
