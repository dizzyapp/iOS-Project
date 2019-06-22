//
//  SignInWebservice.swift
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

class SignInWebservice: WebServiceType {
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        
        switch resource.path {
        case "signInWithDizzy":
            signInWithDizzy(resource, completion: completion)
        case "signInWithFacebook":
            signInWithFacebook(resource, completion: completion)
        default:
            return
        }
    }
    
    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        switch resource.path {
        case "signInWithDizzy":
            return true
        case "signInWithFacebook":
            return true
        default:
            return false
        }
    }
    
    func signInWithDizzy<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable {
        
        guard let signInDetails = resource.getData() as? SignInDetails else {
            return
        }
        Auth.auth().signIn(withEmail: signInDetails.email, password: signInDetails.password) { (result, _) in
            guard let result = result else { return }
            let user = DizzyUser(id: result.user.uid, fullName: "", email: result.user.email!, role: .customer)

            let response = Result.success(user)
            completion(response as! Result<Response>)
        }
    }
    
    func signInWithFacebook<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [Permission.publicProfile], viewController: self.presentingVC) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let connection = GraphRequestConnection()
                connection.add(profileRequest()) { response, result in
                    switch result {
                    case .success(let response):
                        print("Custom Graph Request Succeeded: \(response)")
                        print("My facebook id is \(response.dictionaryValue?["id"])")
                        print("My name is \(response.dictionaryValue?["name"])")
                    case .failed(let error):
                        print("Custom Graph Request Failed: \(error)")
                    }
                }
            }
        }
    }
}
