//
//  MapCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol MapCoordinatorType: NavigationCoordinator {
    var presentingViewController: UIViewController { get }
    var onCoordinatorFinished: () -> Void { get set }
}

final class MapCoordinator: MapCoordinatorType, ReserveTableDisplayer {
    
    var navigationController: UINavigationController
    var container: Container?
    var childCoordinators: [CoordinatorKey : Coordinator] = [:]
    var presentingViewController: UIViewController

    private var mapViewModel: MapVMType?

    var onCoordinatorFinished: () -> Void = { }

    init(container: Container,
         presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
        navigationController = UINavigationController()
    }

    func start() {
        guard var viewModel = container?.resolve(MapVMType.self),
            let googleMap = container?.resolve(MapType.self),
            let mapVC = container?.resolve(MapVC.self, arguments: viewModel, googleMap) else {
                print("could not create MapVC page")
                return
        }
        
        self.mapViewModel = viewModel
        viewModel.delegate = self
        let navigationController = mapVC.embdedInNavigationController().withTransparentStyle()
        self.navigationController = navigationController
        navigationController.modalPresentationStyle = .fullScreen
        presentingViewController.present(navigationController, animated: true)
    }
}

extension MapCoordinator: MapVMDelegate {
 
    func closeButtonPressed() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.onCoordinatorFinished()
        }
    }

    func searchButtonPressed() {
        guard let presentingViewController = navigationController.topViewController,
            let searchCoordinator = container?.resolve(SearchPlaceCoordinatorType.self, argument: presentingViewController) else {
            print("Could not create SearhPlaceCoordinator")
            return
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        searchCoordinator.delegate = self
        add(coordinator: searchCoordinator, for: .placeSearch)
        searchCoordinator.start()
    }
    
    func placeDetailsPressed(_ placeInfo: PlaceInfo) {
        
        guard let presntingVC = self.navigationController.viewControllers.last,
            let activePlace = container?.resolve(ActivePlace.self),
            let placesInteractor  = container?.resolve(PlacesInteractorType.self),
            let placeProfileCoordinator = container?.resolve(PlaceProfileCoordinatorType.self, argument: presntingVC as UIViewController),
            let asyncMediaLoader = container?.resolve(AsyncMediaLoaderType.self) else {
                print("could not create placeProfileCoordinator")
                return
        }
        
        placeProfileCoordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .placeProfile)
        }
        
        container?.register(PlaceProfileVMType.self) { _ in
            PlaceProfileVM(placeInfo: placeInfo, activePlace: activePlace, placesInteractor: placesInteractor, asyncMediaLoader: asyncMediaLoader)
        }
        
        placeProfileCoordinator.start()
        add(coordinator: placeProfileCoordinator, for: .placeProfile)
    }
    
    func placeIconPressed(_ placeInfo: PlaceInfo) {
        guard let presntingVC = self.navigationController.viewControllers.last,
            let placeStoryCoordinator = container?.resolve(PlaceStoryCoordinatorType.self, argument: presntingVC),
            let commentsInteractor = container?.resolve(CommentsInteractorType.self),
            let storiesInteractor = container?.resolve(StoriesInteractorType.self),
            let usersInteractor = container?.resolve(UsersInteracteorType.self),
            let placesInteractor = container?.resolve(PlacesInteractorType.self),
            let user = container?.resolve(DizzyUser.self),
            let asyncMediaLoader = container?.resolve(AsyncMediaLoaderType.self) else {
                print("could not create placeProfileCoordinator")
                return
        }
        
        container?.register(PlaceStoryVMType.self) { _ in
            PlaceStoryVM(place: placeInfo, commentsInteractor: commentsInteractor, storiesInteractor: storiesInteractor, user: user, usersInteractor: usersInteractor, placesIteractor: placesInteractor, asyncMediaLoader: asyncMediaLoader)
        }
        
        placeStoryCoordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .placeStory)
        }
        
        placeStoryCoordinator.start()
        add(coordinator: placeStoryCoordinator, for: .placeStory)
    }
    
    func placeReservePressed(_ placeInfo: PlaceInfo) {
         showReservation(with: placeInfo)
     }
}

extension MapCoordinator: SearchPlaceCoordinatorDelegate {
    func searchPlaceCoordinatorDidSelect(place: PlaceInfo) {
        navigationController.setNavigationBarHidden(false, animated: false)
        mapViewModel?.didSelect(place: place)
    }
    
    func searchPlaceCoordinatorDidCancel() {
        navigationController.setNavigationBarHidden(false, animated: false)
        removeCoordinator(for: .placeSearch)
    }
}
