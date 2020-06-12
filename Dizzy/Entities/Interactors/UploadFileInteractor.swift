//
//  UploadFileInteractor.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 30/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol UploadFileInteractorType {
    func uplaodImage(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<PlaceMedia>) -> Void)
    func uplaodVideo(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<PlaceMedia>) -> Void)
}

final class UploadFileInteractor: UploadFileInteractorType {
    let dispacher: WebServiceDispatcherType
    
    init(dispacher: WebServiceDispatcherType) {
        self.dispacher = dispacher
    }
    
    func uplaodImage(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<PlaceMedia>) -> Void) {
        dispacher.uploadFile(path: path, data: data) { [weak self] result in
            
            switch result {
            case .success(let uploadFileResponse):
                self?.save(placeMedia: uploadFileResponse, to: placeInfo)
                completion(Result.success(uploadFileResponse))
                
            case .failure(let error):
               completion(Result.failure(error))
            }
        }
    }
    
    func uplaodVideo(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<PlaceMedia>) -> Void) {
        dispacher.uploadFile(path: path, data: data) { [weak self] result in
            
            switch result {
            case .success(let uploadFileResponse):
                self?.save(placeMedia: uploadFileResponse, to: placeInfo)
                completion(Result.success(uploadFileResponse))
                
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    private func save(placeMedia: PlaceMedia,to placeInfo: PlaceInfo) {
        let resource = Resource<Bool, PlaceMedia>(path: "placeStoriesPerPlaceId/\(placeInfo.id)/\(UUID().uuidString)").withPost(placeMedia)
        dispacher.load(resource) { _ in }
    }
}
