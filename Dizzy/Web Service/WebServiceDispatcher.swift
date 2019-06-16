//
//  WebServiceDispatcher.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol WebServiceDispatcherType {
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void)
}

final class WebServiceDispatcher: WebServiceDispatcherType {

    private let webServices: [WebServiceType]
    
    init() {
        self.webServices = [FirebaseWebService(), SignupWebservice(), SignInWebservice()]
    }
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) {
        for service in webServices {
            if service.shouldHandle(resource) {
                service.load(resource, completion: completion)
            }
        }
    }
}
