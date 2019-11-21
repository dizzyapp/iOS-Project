//
//  PlaceStoryVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 25/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceStoryVMDelegate: class {
    func placeStoryShowVideo(_ viewModel: PlaceStoryVMType, stringURL: String)
    func placeStoryShowImage(_ viewModel: PlaceStoryVMType, stringURL: String)
    func placeStoryClearTextFieldText(_ viewModel: PlaceStoryVMType)
    func showPopupWithText(_ text: String, title: String)
}

protocol PlaceStoryVMNavigationDelegate: class {
    func placeStoryVMDidFinised(_ viewModel: PlaceStoryVMType)
}

protocol PlaceStoryVMType {
    var delay: Double { get }
    var comments: Observable<[CommentWithWriter]> { get }
    var stories: Observable<[PlaceMedia]> { get }
    var delegate: PlaceStoryVMDelegate? { get set }
    var navigationDelegate: PlaceStoryVMNavigationDelegate? {get set}
    var place: PlaceInfo { get }
    
    func showNextImage()
    func showPrevImage()
    func send(message: String)
    func close()
    
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> CommentWithWriter
}

final class PlaceStoryVM: PlaceStoryVMType {
    
    var place: PlaceInfo
    weak var delegate: PlaceStoryVMDelegate?
    weak var navigationDelegate: PlaceStoryVMNavigationDelegate?
    
    var displayedImageIndex = -1
    let delay = 1000.0
    var commentsInteractor: CommentsInteractorType
    var storiesInteractor: StoriesInteractorType
    let placesIteractor: PlacesInteractorType
    var comments = Observable<[CommentWithWriter]>([CommentWithWriter]())
    var stories = Observable<[PlaceMedia]>([PlaceMedia]())
    let usersInteractor: UsersInteracteorType
    let user: DizzyUser
    
    init(place: PlaceInfo, commentsInteractor: CommentsInteractorType, storiesInteractor: StoriesInteractorType, user: DizzyUser, usersInteractor: UsersInteracteorType, placesIteractor: PlacesInteractorType) {
        self.place = place
        self.commentsInteractor = commentsInteractor
        self.storiesInteractor = storiesInteractor
        self.user = user
        self.usersInteractor = usersInteractor
        self.storiesInteractor.getAllPlaceStories(with: place.id)
        self.placesIteractor = placesIteractor
        self.commentsInteractor.delegate = self
        self.storiesInteractor.delegate = self
    }
    
    func showNextImage() {
        if displayedImageIndex + 1 <= stories.value.count - 1 {
            displayedImageIndex += 1
            let mediaToShow = stories.value[displayedImageIndex]
            guard let mediaUrl = mediaToShow.downloadLink else { return }
            if mediaToShow.isVideo() {
                delegate?.placeStoryShowVideo(self, stringURL: mediaUrl)
            } else {
                delegate?.placeStoryShowImage(self, stringURL: mediaUrl)
            }
        } else {
            navigationDelegate?.placeStoryVMDidFinised(self)
        }
    }
    
    func showPrevImage() {
        if displayedImageIndex - 1 >= 0 {
            displayedImageIndex -= 1
            let mediaToShow = stories.value[displayedImageIndex]
            guard let mediaUrl = mediaToShow.downloadLink else { return }
            if mediaToShow.isVideo() {
                delegate?.placeStoryShowVideo(self, stringURL: mediaUrl)
            } else {
                delegate?.placeStoryShowImage(self, stringURL: mediaUrl)
            }
        }
    }
    
    func send(message: String) {
        guard user.role != .guest else {
            self.delegate?.showPopupWithText("You must be logged in, in order to comment to a story".localized, title: "Please login or sign up".localized)
            return
        }
        let comment = Comment(id: UUID().uuidString, value: message, timeStamp: Date().timeIntervalSince1970, writerId: user.id)
        commentsInteractor.sendComment(comment, placeId: place.id)
        self.delegate?.placeStoryClearTextFieldText(self)
    }
    
    func numberOfRowsInSection() -> Int {
        return comments.value.count
    }
    
    func comment(at indexPath: IndexPath) -> CommentWithWriter {
        return comments.value[indexPath.row]
    }
    
    func close() {
        navigationDelegate?.placeStoryVMDidFinised(self)
    }
}

extension PlaceStoryVM: CommentsInteractorDelegate {
    func commentsInteractor(_ interactor: CommentsInteractorType, comments: [Comment]) {
        
        let sortedComments = comments.sorted { $0.timeStamp < $1.timeStamp }
        usersInteractor.getAllUsers { [weak self] allUsers in
            let allCommentsWithUser = sortedComments.map({  comment -> CommentWithWriter in
                
                let user = allUsers.first(where: { user in
                    user.id == comment.writerId
                })
                
                return CommentWithWriter(comment: comment, writer: user!)
            })
            
            self?.comments.value = allCommentsWithUser
        }
    }
}

extension PlaceStoryVM: StoriesInteractorDelegate {
    func storiesInteractor(_ interactor: StoriesInteractorType, stories: [PlaceMedia]?) {
        if let stories = stories, !stories.isEmpty {
            self.stories.value = sortStoriesByTimeStamp(unsorterdStories: stories)
            
            self.showNextImage()
            self.commentsInteractor.getAllComments(forPlaceId: place.id)
        }
    }
    
    private func sortStoriesByTimeStamp(unsorterdStories: [PlaceMedia]) -> [PlaceMedia] {
        return unsorterdStories.sorted(by: { (mediaA, mediaB) -> Bool in
            guard let timeStampA = mediaA.timeStamp,
                let timeStampB = mediaB.timeStamp else {
                    return mediaA.timeStamp != nil
            }
            return timeStampA < timeStampB
        })
    }
}
