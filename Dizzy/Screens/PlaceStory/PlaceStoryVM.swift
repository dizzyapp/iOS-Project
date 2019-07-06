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
    func placeStoryShowVideo(_ viewModel: PlaceStoryVMType, stringURL: String)

}

protocol PlaceStoryVMType {
    var currentImageURLString: Observable<String?> { get set }
    var delay: Double { get }
    var comments: Observable<[Comment]> { get }
    var stories: Observable<[PlaceStory]> { get }
    var delegate: PlaceStoryVMDelegate? { get set }
    var place: PlaceInfo { get }
    
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
    
    var imagesURL = [String]()
    
    var displayedImageIndex = -1
    let delay = 1000.0
    var commentsInteractor: CommentsInteractorType
    var storiesInteractor: StoriesInteractorType
    var comments = Observable<[Comment]>([Comment]())
    var stories = Observable<[PlaceStory]>([PlaceStory]())
    
    var currentImageURLString = Observable<String?>(nil)
    
    init(place: PlaceInfo, commentsInteractor: CommentsInteractorType, storiesInteractor: StoriesInteractorType) {
        self.place = place
        self.commentsInteractor = commentsInteractor
        self.storiesInteractor = storiesInteractor
        self.storiesInteractor.getAllPlaceStories(with: place.id)
        self.commentsInteractor.delegate = self
        self.storiesInteractor.delegate = self
    }
    
    func showNextImage() {
        if displayedImageIndex + 1 <= imagesURL.count - 1 {
            displayedImageIndex += 1
            if isVideo(string: imagesURL[displayedImageIndex]) {
                delegate?.placeStoryShowVideo(self, stringURL: imagesURL[displayedImageIndex])
            } else {
                currentImageURLString.value = imagesURL[displayedImageIndex]
            }
        } else {
            delegate?.placeStoryVMDidFinised(self)
        }
    }
    
    func showPrevImage() {
        if displayedImageIndex - 1 >= 0 {
            displayedImageIndex -= 1
            if isVideo(string: imagesURL[displayedImageIndex]) {
                delegate?.placeStoryShowVideo(self, stringURL: imagesURL[displayedImageIndex])
            } else {
                currentImageURLString.value = imagesURL[displayedImageIndex]
            }
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
    
    private func isVideo(string: String) -> Bool {
        return string.contains(".MOV")
    }
}

extension PlaceStoryVM: CommentsInteractorDelegate {
    func commentsInteractor(_ interactor: CommentsInteractorType, comments: [Comment]) {
        
        let sortedComments = comments.sorted { $0.timeStamp < $1.timeStamp }
        self.comments.value = sortedComments
    }
}

extension PlaceStoryVM: StoriesInteractorDelegate {
    func storiesInteractor(_ interactor: StoriesInteractorType, stories: [PlaceStory]?) {
        if let stories = stories, !stories.isEmpty {
            self.stories.value = stories
            self.imagesURL = stories.filter { $0.downloadLink != nil }.map { $0.downloadLink! }
            
            self.showNextImage()
            self.commentsInteractor.getAllPlaceComments(with: place.id)
        }
    }
}
