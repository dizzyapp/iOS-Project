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
    var showImage: (String) -> Void { get set }
    var delay: Double { get }
    
    func showNextImage()
    func showPrevImage()
}

final class PlaceStoryVM: PlaceStoryVMType {
    
    let place: PlaceInfo
    weak var delegate: PlaceStoryVMDelegate?
    
    let imagesURL = ["https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fimg_lights.jpg?alt=media&token=8fca6a7b-635f-4d8f-8382-75b989575478",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2FUntitled.mov?alt=media&token=0f1dc506-1931-400c-bdcd-d5bab1cde8eb",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fdownload.jpeg?alt=media&token=3134672a-ebd2-4ffc-9c40-3f82449a5029",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fgoogle.jpg?alt=media&token=c4da324d-81bf-4faa-99c3-54dcd0476eea",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Fimage.jpg?alt=media&token=ef6255b1-fad1-41c8-884f-b705a037d690",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2FmoreImages.jpeg?alt=media&token=34a022aa-c32d-4df2-a4de-5fba4121039f",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2FSetup%20Wars%20-%20Episode%20168.mp4?alt=media&token=31760a4f-2b73-4d7b-81bd-a27c76cd5c89",
                     "https://firebasestorage.googleapis.com/v0/b/dizzy-7bc88.appspot.com/o/Test%2Ftest.jpg?alt=media&token=ccb431c5-4289-491c-becc-b3255ccd98fb"] //tempData
    
    var showImage: (String) -> Void = { _ in }
    var displayedImageIndex = -1
    let delay = 1000.0
    
    init(place: PlaceInfo) {
        self.place = place
    }
    
    func showNextImage() {
        if displayedImageIndex + 1 <= imagesURL.count - 1 {
            displayedImageIndex += 1
            showImage(imagesURL[displayedImageIndex])
        } else {
            delegate?.placeStoryVMDidFinised(self)
        }
    }
    
    func showPrevImage() {
        if displayedImageIndex - 1 >= 0 {
            displayedImageIndex -= 1
            showImage(imagesURL[displayedImageIndex])
        }
    }
}
