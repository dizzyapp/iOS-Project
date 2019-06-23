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
            let user = DizzyUser(id: result.user.uid, fullName: "", email: result.user.email!, role: .customer, photoURL: nil)

            let response = Result.success(user)
            completion(response as! Result<Response>)
        }
    }
    
    func signInWithFacebook<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [Permission.publicProfile.name, Permission.email.name], from: resource.presentedVC) { (loginResult, error) in
            
            guard let result = loginResult else {
                return
            }
            if result.isCancelled {
                print("is cancelled")
            }
            if result.grantedPermissions.isEmpty {
                print("declined")
            } else {
                print("granted")
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (dataResult, error) in
                    
                    guard let result = dataResult else { return }
                    let user = DizzyUser(id: result.user.uid,
                                         fullName: result.user.displayName ?? "",
                                         email: result.user.email!,
                                         role: .customer,
                                         photoURL: result.user.photoURL)
                    
                    let response = Result.success(user)
                    completion(response as! Result<Response>)
                })
            }
        }
    }
    
//    private func fetchUserDetails(completion: @escaping (_ result: [String: String]) -> Void) {
//        let connection = GraphRequestConnection()
//        connection.add(ProfileRequest()) { response, result in
//            switch result {
//            case .success(let response):
//                print("Custom Graph Request Succeeded: \(response)")
//                print("My facebook id is \(response.dictionaryValue?["id"])")
//                print("My name is \(response.dictionaryValue?["name"])")
//            case .failed(let error):
//                print("Custom Graph Request Failed: \(error)")
//            }
//        }
//        connection.start()
//    }
}
