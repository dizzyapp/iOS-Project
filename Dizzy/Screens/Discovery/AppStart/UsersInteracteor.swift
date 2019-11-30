//
//  LoggedInUsersInteracteor.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol UsersInteracteorType {
    func getAllUsers(_ completion: @escaping ([DizzyUser]) -> Void)
    func getUser(_ completion: @escaping (DizzyUser?) -> Void)
    func getUserForId(userId: String, _ completion: @escaping (DizzyUser?) -> Void)
    func saveUserOnRemote(_ user: DizzyUser)
    func saveProfileImage(_ image: UIImage, forUser user: DizzyUser)
}

class UsersInteracteor: UsersInteracteorType {

    private let userDefaults: MyUserDefaultsType
    private let webResourcesDispatcher: WebServiceDispatcherType
    
    init(userDefaults: MyUserDefaultsType, webResourcesDispatcher: WebServiceDispatcherType) {
        self.userDefaults = userDefaults
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    func getAllUsers(_ completion: @escaping ([DizzyUser]) -> Void) {
        let resource = Resource<[DizzyUser], String>(path: "users").withGet()
        webResourcesDispatcher.load(resource) { result in
            switch result {
            case .failure:
                print("failed to get all users")
                return
            case .success(let users):
                completion(users)
                return
            }
        }
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
            case .failure:
                print("failed to get user for id: \(loggedInUserId)")
                return
            case .success(let user):
                completion(user)
                return
            }
        }
    }
    
    func getUserForId(userId: String, _ completion: @escaping (DizzyUser?) -> Void) {
        let resource = Resource<DizzyUser, String>(path: "users/\(userId)").withGet()
        webResourcesDispatcher.load(resource) { result in
            switch result {
            case .failure:
                print("failed to get user for id: \(userId)")
                return
            case .success(let user):
                completion(user)
                return
            }
        }
    }
    
    func saveUserOnRemote(_ user: DizzyUser) {
        let saveUserResource = Resource<String, DizzyUser>(path: "users/\(user.id)").withPost(user)
        webResourcesDispatcher.load(saveUserResource) { result in
            switch result {
            case .failure:
                print("could not save user on remote")
            case .success:
                print("usert saved successfully")
            }
        }
    }
    
    func saveProfileImage(_ image: UIImage, forUser user: DizzyUser) {
        let uploadImageData = UploadFileData(data: image.pngData(), fileURL: nil)
        webResourcesDispatcher.uploadFile(path: "users/\(user.id)/profileImage", data: uploadImageData) {[weak self] results in
            switch results {
            case .success(let uploadedMedia):
                guard let profileImageUrl = uploadedMedia.downloadLink else { return }
                self?.saveProfileImageUrl(profileImageUrl, forUser: user)
            case .failure(let error):
                print("could not upload profile image")
                print(error)
            }
        }
    }
    
    private func saveProfileImageUrl(_ imageUrl: String, forUser user: DizzyUser) {
        var userWithNewImage = user
        userWithNewImage.photoURL = URL(string: imageUrl)
        saveUserOnRemote(userWithNewImage)
    }
}
