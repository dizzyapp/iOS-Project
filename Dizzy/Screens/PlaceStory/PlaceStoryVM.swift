//
//  PlaceStoryVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 25/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceStoryVMDelegate: class {
    func placeStoryVMDidFinised(_ viewModel: PlaceStoryVMType)
}

protocol PlaceStoryVMType {
    var currentImageURLString: Observable<String?> { get set }
    var delay: Double { get }
    
    func showNextImage()
    func showPrevImage()
}

final class PlaceStoryVM: PlaceStoryVMType {
    
    let place: PlaceInfo
    weak var delegate: PlaceStoryVMDelegate?
    
    let imagesURL = ["https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fimg_lights.jpg?alt=media&token=8fca6a7b-635f-4d8f-8382-75b989575478",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2FIMG_2073.MOV?alt=media&token=b559f227-8884-482f-bd4d-1ce8564883bc",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fdownload.jpeg?alt=media&token=3134672a-ebd2-4ffc-9c40-3f82449a5029",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fgoogle.jpg?alt=media&token=c4da324d-81bf-4faa-99c3-54dcd0476eea",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fimage.jpg?alt=media&token=ef6255b1-fad1-41c8-884f-b705a037d690",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2FmoreImages.jpeg?alt=media&token=34a022aa-c32d-4df2-a4de-5fba4121039f",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2FIMG_2073.MOV?alt=media&token=b559f227-8884-482f-bd4d-1ce8564883bc",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Ftest.jpg?alt=media&token=ccb431c5-4289-491c-becc-b3255ccd98fb"] //tempData
    
    var displayedImageIndex = -1
    let delay = 1000.0
    
    var currentImageURLString = Observable<String?>(nil)
    
    init(place: PlaceInfo) {
        self.place = place
    }
    
    func showNextImage() {
        if displayedImageIndex + 1 <= imagesURL.count - 1 {
            displayedImageIndex += 1
            currentImageURLString.value = imagesURL[displayedImageIndex]
        } else {
            delegate?.placeStoryVMDidFinised(self)
        }
    }
    
    func showPrevImage() {
        if displayedImageIndex - 1 >= 0 {
            displayedImageIndex -= 1
            currentImageURLString.value = imagesURL[displayedImageIndex]
        }
    }
}
