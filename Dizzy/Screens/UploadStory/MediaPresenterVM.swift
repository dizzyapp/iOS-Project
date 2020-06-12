//
//  MediaPresenterVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

enum PresentedMediaType {
    case image(image: UIImage)
    case video(videoURL: URL)
}

protocol MediaPresenterVMType {
    var presentedMediaType: PresentedMediaType { get }
    var delegate: MediaPresenterVMDelegate? { get set }
    var placeIconURL: URL? { get }
    
    func backPressed()
    func uploadPressed()
}

protocol MediaPresenterVMDelegate: class {
    func photoPresenterVMBackPressed(_ viewModel: MediaPresenterVMType)
    func photoPresenterVMUploadPressed(_ videwModel: MediaPresenterVMType)
}

final class MediaPresenterVM: MediaPresenterVMType {
    
    var presentedMediaType: PresentedMediaType
    let uploadFileInteractor: UploadFileInteractorType
    let placesInteractor: PlacesInteractorType
    let placeInfo: PlaceInfo
    
    weak var delegate: MediaPresenterVMDelegate?
    
    var placeIconURL: URL? {
        return URL(string: placeInfo.imageURLString ?? "")
    }
    
    init(presentedMediaType: PresentedMediaType,
         uploadFileInteractor: UploadFileInteractorType,
         placesInteractor: PlacesInteractorType,
         placeInfo: PlaceInfo) {
        self.presentedMediaType = presentedMediaType
        self.uploadFileInteractor = uploadFileInteractor
        self.placesInteractor = placesInteractor
        self.placeInfo = placeInfo
    }
    
    func backPressed() {
        delegate?.photoPresenterVMBackPressed(self)
    }
    
    func uploadPressed() {
        let uploadCompletion = getUploadCompletionCalback()
        switch presentedMediaType {
        case .video(let videoLocalURL):
            uploadVideo(videoLocalUrl: videoLocalURL, completion: uploadCompletion)
        case .image(let image):
            uploadImage(image: image, completion: uploadCompletion)
        }
    }
    
    private func uploadImage(image: UIImage, completion: @escaping (Result<PlaceMedia>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        let uploadData = UploadFileData(data: data, fileURL: nil)
        
        uploadFileInteractor.uplaodImage(path: "\(placeInfo.name)/\(UUID().uuidString)", data: uploadData, placeInfo: placeInfo, completion: completion)
        delegate?.photoPresenterVMUploadPressed(self)
    }
    
    private func uploadVideo(videoLocalUrl: URL, completion: @escaping (Result<PlaceMedia>) -> Void) {
        uploadFileInteractor.uplaodVideo(path: "\(placeInfo.name)/\(UUID().uuidString).mp4", data: UploadFileData(data: nil, fileURL: videoLocalUrl), placeInfo: placeInfo, completion: completion)
        delegate?.photoPresenterVMUploadPressed(self)
    }
    
    private func getUploadCompletionCalback() -> (Result<PlaceMedia>) -> Void {
        let placesInteractorCopy = self.placesInteractor
        let placeInfoCopy = self.placeInfo
        
        let uploadMediaCompletion = { (results: Result<PlaceMedia>) -> Void in
            switch results {
            case .success(let placeMedia):
                guard let timeStamp = placeMedia.timeStamp else { return }
                placesInteractorCopy.updateLastStoryTimeStamp(timeStamp: timeStamp, forPlaceInfo: placeInfoCopy)
            case .failure(let error):
                print(error)
            }
        }
        
        return uploadMediaCompletion
    }
}
