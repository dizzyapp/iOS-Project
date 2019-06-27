//
//  SignupWebservice.swift
//  Dizzy
//
//  Created by Menashe, Or on 09/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore

class LogoutWebService: WebServiceType {
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        
        switch resource.path {
        case "logout":
            logout(resource, completion: completion)
        default:
            return
        }
    }
    
    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        switch resource.path {
        case "logout":
            return true
        default:
            return false
        }
    }
    
    func logout<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        
        do {
            try Auth.auth().signOut()
            LoginManager().logOut()
            let response = Result.success("")
            completion(response as! Result<Response>)
        } catch let error {
            completion(.failure(error))
        }
    }
}
