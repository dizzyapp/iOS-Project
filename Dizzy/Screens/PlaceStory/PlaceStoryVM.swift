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
    func placeStoryClearTextFieldText(_ viewModel: PlaceStoryVMType)
    func showPopupWithText(_ text: String, title: String)
}

protocol PlaceStoryVMNavigationDelegate: class {
    func placeStoryVMDidFinised(_ viewModel: PlaceStoryVMType)
}

protocol PlaceStoryVMType {
    var currentImageURLString: Observable<String?> { get set }
    var delay: Double { get }
    var comments: Observable<[CommentWithWriter]> { get }
    var stories: Observable<[PlaceStory]> { get }
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
    
    let place: PlaceInfo
    weak var delegate: PlaceStoryVMDelegate?
    weak var navigationDelegate: PlaceStoryVMNavigationDelegate?
    
    var imagesURL = [String]()
    
    var displayedImageIndex = -1
    let delay = 1000.0
    var commentsInteractor: CommentsInteractorType
    var storiesInteractor: StoriesInteractorType
    var comments = Observable<[CommentWithWriter]>([CommentWithWriter]())
    var stories = Observable<[PlaceStory]>([PlaceStory]())
    let usersInteractor: UsersInteracteorType
    let user: DizzyUser
    
    var currentImageURLString = Observable<String?>(nil)
    
    init(place: PlaceInfo, commentsInteractor: CommentsInteractorType, storiesInteractor: StoriesInteractorType, user: DizzyUser, usersInteractor: UsersInteracteorType) {
        self.place = place
        self.commentsInteractor = commentsInteractor
        self.storiesInteractor = storiesInteractor
        self.user = user
        self.usersInteractor = usersInteractor
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
            navigationDelegate?.placeStoryVMDidFinised(self)
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
    
    private func isVideo(string: String) -> Bool {
        return string.contains(".mp4") || string.contains(".mov")
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
    func storiesInteractor(_ interactor: StoriesInteractorType, stories: [PlaceStory]?) {
        if let stories = stories, !stories.isEmpty {
            self.stories.value = stories
            self.imagesURL = stories.filter { $0.downloadLink != nil }.map { $0.downloadLink! }
            
            self.showNextImage()
            self.commentsInteractor.getAllComments(forPlaceId: place.id)
        }
    }
}
