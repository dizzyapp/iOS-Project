//
//  SignupWebservice.swift
//  Dizzy
//
//  Created by Menashe, Or on 09/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupWebservice: WebServiceType {
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        switch resource.path {
        case "signupWithDizzy":
            guard let resource = resource as? Resource<String, SignupDetails>,
                let completion = completion as? ((Result<String>) -> Void) else {
                return
            }
            signupWithDizzy(resource, completion: completion)
        default:
            return
        }
        
    }
    
    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        switch resource.path {
        case "signupWithDizzy":
            return true
        default:
                return false
        }
    }
    
    func signupWithDizzy<Response>(_ resource: Resource<Response, SignupDetails>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable {
        
        if let method = resource.method, case let .post(signUpDetails) = method {
            Auth.auth().createUser(withEmail: signUpDetails.email, password: signUpDetails.password) { (authDataResult, error) in
                print(error)
                print(authDataResult)
            }
        }
    }
}
