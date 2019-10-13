//
//  UploadFileInteractor.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 30/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol UploadFileInteractorType {
    func uplaodImage(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<Bool>) -> Void)
    func uplaodVideo(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<Bool>) -> Void)
}

final class UploadFileInteractor: UploadFileInteractorType {
    let dispacher: WebServiceDispatcherType
    
    init(dispacher: WebServiceDispatcherType) {
        self.dispacher = dispacher
    }
    
    func uplaodImage(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<Bool>) -> Void) {
        dispacher.uploadFile(path: path, data: data) { [weak self] result in
            
            switch result {
            case .success(let uploadFileResponse):
                self?.save(uploadedFileLink: uploadFileResponse.downloadLink, to: placeInfo)
                completion(Result.success(true))
                
            case .failure(let error):
               completion(Result.failure(error))
            }
        }
    }
    
    func uplaodVideo(path: String, data: UploadFileData, placeInfo: PlaceInfo, completion: @escaping (Result<Bool>) -> Void) {
        dispacher.uploadFile(path: path, data: data) { [weak self] result in
            
            switch result {
            case .success(let uploadFileResponse):
                self?.save(uploadedFileLink: uploadFileResponse.downloadLink, to: placeInfo)
                completion(Result.success(true))
                
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    private func save(uploadedFileLink: String,to placeInfo: PlaceInfo) {
        let resource = Resource<Bool, UploadFileResponse>(path: "placeStoriesPerPlaceId/\(placeInfo.id)/\(UUID().uuidString)").withPost(UploadFileResponse(downloadLink: uploadedFileLink))
        dispacher.load(resource) { _ in }
    }
}
