//
//  StoryCoordinatorOpener.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol StoryCoordinatorOpener {
    func showPlaceStory(placeInfo: PlaceInfo, presentingVC: UIViewController?)
}

extension StoryCoordinatorOpener where Self: Coordinator {
    func showPlaceStory(placeInfo: PlaceInfo, presentingVC: UIViewController?) {
        guard let presntingVC = presentingVC,
            let placeStoryCoordinator = container?.resolve(PlaceStoryCoordinatorType.self, argument: presntingVC),
            let commentsInteractor = container?.resolve(CommentsInteractorType.self),
            let storiesInteractor = container?.resolve(StoriesInteractorType.self),
            let usersInteractor = container?.resolve(UsersInteracteorType.self),
            let placesInteractor = container?.resolve(PlacesInteractorType.self),
            let user = container?.resolve(DizzyUser.self) else {
                print("could not create placeProfileCoordinator")
                return
        }
        
        container?.register(PlaceStoryVMType.self) { _ in
            PlaceStoryVM(place: placeInfo, commentsInteractor: commentsInteractor, storiesInteractor: storiesInteractor, user: user, usersInteractor: usersInteractor, placesIteractor: placesInteractor)
        }
        
        placeStoryCoordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .placeStory)
        }
        
        placeStoryCoordinator.start()
        add(coordinator: placeStoryCoordinator, for: .placeStory)
    }
}
