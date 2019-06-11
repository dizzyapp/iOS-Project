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
    var comments: Observable<[Comment]> { get }
    var delegate: PlaceStoryVMDelegate? { get set }
    
    func showNextImage()
    func showPrevImage()
    func send(comment: Comment)
    func close()
    
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> Comment
}

final class PlaceStoryVM: PlaceStoryVMType {
    
    let place: PlaceInfo
    weak var delegate: PlaceStoryVMDelegate?
    
    var imagesURL = [String?]()
    
    var displayedImageIndex = -1
    let delay = 1000.0
    var commentsInteractor: CommentsInteractorType
    var comments = Observable<[Comment]>([Comment]())
    
    var currentImageURLString = Observable<String?>(nil)
    
    init(place: PlaceInfo, commentsInteractor: CommentsInteractorType) {
        self.place = place
        self.commentsInteractor = commentsInteractor
        self.commentsInteractor.getAllPlaceComments(with: place.id)
        self.commentsInteractor.delegate = self
        
        if let placesStories = place.placesStories {
            imagesURL = placesStories
        }
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
    
    func send(comment: Comment) {
        commentsInteractor.sendComment(comment, placeId: place.id)
    }
    
    func numberOfRowsInSection() -> Int {
        return comments.value.count
    }
    
    func comment(at indexPath: IndexPath) -> Comment {
        return comments.value[indexPath.row]
    }
    
    func close() {
        delegate?.placeStoryVMDidFinised(self)
    }
}

extension PlaceStoryVM: CommentsInteractorDelegate {
    func commentsInteractor(_ interactor: CommentsInteractorType, comments: [Comment]) {
        let sortedComments = comments.sorted { $0.timeStamp < $1.timeStamp }
        self.comments.value = sortedComments
    }
}
