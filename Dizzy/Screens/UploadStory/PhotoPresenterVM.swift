//
//  PhotoPresenterVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol PhotoPresenterVMType {
    var photo: UIImage { get }
    var loading: Observable<Bool> { get }
    var delegate: PhotoPresenterVMDelegate? { get set }
    var placeIconURL: URL? { get }
    
    func backPressed()
    func uploadImageTapped()
}

protocol PhotoPresenterVMDelegate: class {
    func photoPresenterVMBackPressed(_ viewModel: PhotoPresenterVMType)
    func photoPresenterVMUploadPressed(_ videwModel: PhotoPresenterVMType)
}

final class PhotoPresenterVM: PhotoPresenterVMType {
    
    var photo: UIImage
    let uploadFileInteractor: UploadFileInteractorType
    let placeInfo: PlaceInfo
    var loading = Observable<Bool>(false)
    
    weak var delegate: PhotoPresenterVMDelegate?
    
    var placeIconURL: URL? {
        return URL(string: placeInfo.imageURLString ?? "")
    }
    
    init(photo: UIImage,
         uploadFileInteractor: UploadFileInteractorType,
         placeInfo: PlaceInfo) {
        self.photo = photo
        self.uploadFileInteractor = uploadFileInteractor
        self.placeInfo = placeInfo
    }
    
    func backPressed() {
        delegate?.photoPresenterVMBackPressed(self)
    }
    
    func uploadImageTapped() {
        guard let data = photo.jpegData(compressionQuality: 0.1) else { return }
        loading.value = true
        let uploadData = UploadFileData(data: data)
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
}
