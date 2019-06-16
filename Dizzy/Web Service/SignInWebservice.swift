//
//  SignInWebservice.swift
//  Dizzy
//
//  Created by Menashe, Or on 09/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInWebservice: WebServiceType {
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        
        switch resource.path {
        case "signInWithDizzy":
            signInWithDizzy(resource, completion: completion)
        default:
            return
        }
    }
    
    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        switch resource.path {
        case "signInWithDizzy":
            return true
        default:
            return false
        }
    }
    
    func signInWithDizzy<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable {
        
        guard let loginCredentialsDetails = resource.getData() as? LoginCredentialsDetails else {
            return
        }
        Auth.auth().signIn(withEmail: loginCredentialsDetails.email , password: loginCredentialsDetails.password) { (result, _) in
            guard let result = result else { return }
            let user = DizzyUser(id: result.user.uid, fullName: "", email: result.user.email!, role: .customer)

            let response = Result.success(user)
            completion(response as! Result<Response> )
        }
    }
}
