//
//  MyUserDefaults.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol MyUserDefaultsType {
    func getLogedInUserId() -> String?
    func saveLoggedInUserId(userId: String)
    func clearLoggedInUserId()
}

class MyUserDefaults: MyUserDefaultsType {
    let loggedInUserIdKey = "LOGGED_IN_ID_KEY"
    
    func getLogedInUserId() -> String? {
        return UserDefaults.standard.string(forKey: loggedInUserIdKey)
    }
    
    func saveLoggedInUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: loggedInUserIdKey)
    }
    
    func clearLoggedInUserId() {
        UserDefaults.standard.set(nil, forKey: loggedInUserIdKey)
    }
}
