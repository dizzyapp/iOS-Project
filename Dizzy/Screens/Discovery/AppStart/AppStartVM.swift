//
//  AppStartVM.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol AppStartVMType {
    func getLoggedInUser()
    var appUser: Observable<DizzyUser?> { get }
    var appUserReturned: Bool { get }
}

class AppStartVM: AppStartVMType {
    
    let appUser = Observable<DizzyUser?>(nil)
    var appUserReturned = false
    private var loggedInUsersInteractor: UsersInteracteorType
    
    init(loggedInUsersInteractor: UsersInteracteorType) {
        self.loggedInUsersInteractor = loggedInUsersInteractor
    }
    
    func getLoggedInUser() {
        loggedInUsersInteractor.getUser { [weak self] user in
            self?.appUser.value = user
            self?.appUserReturned = true
        }
    }
}
