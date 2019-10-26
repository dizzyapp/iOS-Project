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
    var loading: Observable<Bool> { get }
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
    let placeInfo: PlaceInfo
    var loading = Observable<Bool>(false)
    
    weak var delegate: MediaPresenterVMDelegate?
    
    var placeIconURL: URL? {
        return URL(string: placeInfo.imageURLString ?? "")
    }
    
    init(presentedMediaType: PresentedMediaType,
         uploadFileInteractor: UploadFileInteractorType,
         placeInfo: PlaceInfo) {
        self.presentedMediaType = presentedMediaType
        self.uploadFileInteractor = uploadFileInteractor
        self.placeInfo = placeInfo
    }
    
    func backPressed() {
        delegate?.photoPresenterVMBackPressed(self)
    }
    
    func uploadPressed() {
        switch presentedMediaType {
        case .video(let videoLocalURL):
            uploadVideo(videoLocalUrl: videoLocalURL)
        case .image(let image):
            uploadImage(image: image)
        }
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        loading.value = true
        let uploadData = UploadFileData(data: data, fileURL: nil)
        uploadFileInteractor.uplaodImage(path: "\(placeInfo.name)/\(UUID().uuidString)", data: uploadData, placeInfo: placeInfo) { result in
            self.loading.value = false
            switch result {
            case .success:
                self.delegate?.photoPresenterVMUploadPressed(self)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func uploadVideo(videoLocalUrl: URL) {
        uploadFileInteractor.uplaodVideo(path: "\(placeInfo.name)/\(UUID().uuidString).mp4", data: UploadFileData(data: nil, fileURL: videoLocalUrl), placeInfo: placeInfo) { result in
            switch result {
            case .success:
                self.delegate?.photoPresenterVMUploadPressed(self)
                return
            case .failure(let error):
                print(error)
            }
        }
    }
}
