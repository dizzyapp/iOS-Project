//
//  CommentsInteractor.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 03/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol CommentsInteractorType {
    var delegate: CommentsInteractorDelegate? { get set }
    
    func getAllPlaceComments(with placeId: String)
    func sendComment(_ comment: Comment, placeId: String)
}

protocol CommentsInteractorDelegate: class {
    func commentsInteractor(_ interactor: CommentsInteractorType, comments: [Comment])
}

final class CommentsInteractor: CommentsInteractorType {

    var dispacher: WebServiceDispatcherType
    weak var delegate: CommentsInteractorDelegate?
    
    init(dispacher: WebServiceDispatcherType) {
        self.dispacher = dispacher
    }
    
    func getAllPlaceComments(with placeId: String) {
        let resource = Resource<[Comment], Bool>(path: "commentPerPlaceId/\(placeId)").withGet()
        dispacher.load(resource) { [weak self] result in
            guard let self = self else { return }// todo:- add error handler
            switch result {
            case .success(let comments):
                self.delegate?.commentsInteractor(self, comments: comments)
                
            case .failure(let error):
                print(error.debugDescription)
            }
        }
    }
    
    func sendComment(_ comment: Comment, placeId: String) {
        let resource = Resource<Bool, Comment>(path: "commentPerPlaceId/\(placeId)").withPost(comment)
        dispacher.load(resource) { _ in }
    }
}
