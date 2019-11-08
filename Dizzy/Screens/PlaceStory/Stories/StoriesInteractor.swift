//
//  StoriesInteractor.swift
//  Dizzy
//
//  Created by Stas Berkman on 03/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol StoriesInteractorType {
    var delegate: StoriesInteractorDelegate? { get set }
    
    func getAllPlaceStories(with placeId: String)
}

protocol StoriesInteractorDelegate: class {
    func storiesInteractor(_ interactor: StoriesInteractorType, stories: [PlaceMedia]?)
}

final class StoriesInteractor: StoriesInteractorType {

    var dispacher: WebServiceDispatcherType
    weak var delegate: StoriesInteractorDelegate?
    
    init(dispacher: WebServiceDispatcherType) {
        self.dispacher = dispacher
    }
    
    func getAllPlaceStories(with placeId: String) {
        let resource = Resource<[PlaceMedia], Bool>(path: "placeStoriesPerPlaceId/\(placeId)").withGet()
        dispacher.load(resource) { [weak self] result in
            guard let self = self else { return }// todo:- add error handler
            switch result {
            case .success(let stories):
                self.delegate?.storiesInteractor(self, stories: stories)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
