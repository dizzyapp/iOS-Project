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
    
    func signupWithDizzy<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable {
        
        guard let loginCredentailsDetails = resource.getData() as? LoginCredentialsDetails else {
            return
        }
        Auth.auth().createUser(withEmail: loginCredentailsDetails.email , password: loginCredentailsDetails.password) { (result, _) in
            guard let result = result else { return }
            let user = DizzyUser(id: result.user.uid, fullName: loginCredentailsDetails.fullName, email: loginCredentailsDetails.email, role: .customer)
            
            let response = Result.success(user)
            completion(response as! Result<Response> )
        }
    }
}
