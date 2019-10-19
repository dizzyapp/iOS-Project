//
//  LoggedInUsersInteracteor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol UsersInteracteorType {
    func getUser(_ completion: @escaping (DizzyUser?) -> Void)
}

class UsersInteracteor: UsersInteracteorType {

    private let userDefaults: MyUserDefaultsType
    private let webResourcesDispatcher: WebServiceDispatcherType
    
    init(userDefaults: MyUserDefaultsType, webResourcesDispatcher: WebServiceDispatcherType) {
        self.userDefaults = userDefaults
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func getUser(_ completion: @escaping (DizzyUser?) -> Void) {
        guard let loggedInUserId = userDefaults.getLogedInUserId() else {
            print("no logged in id")
            completion(nil)
            return
        }
        
        
        let resource = Resource<DizzyUser, String>(path: "users/\(loggedInUserId)").withGet()
        webResourcesDispatcher.load(resource) { result in
            switch result {
            case .failure(let error):
                print("failed to get user for id: \(loggedInUserId)")
                return
            case .success(let user):
                print("menash logs - user arrived: \(user)")
                completion(user)
                return
            }
        }
    }
}
