//
//  HomeCoordinator.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject

protocol HomeCoordinatorType: Coordinator {
    var window: UIWindow { get }
}

final class HomeCoordinator: HomeCoordinatorType {
    
    private var discoveryVC: DiscoveryVC?
    
    var window: UIWindow
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    
    init(container: Container, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        createDiscoveryVC()
        window.rootViewController = discoveryVC
        window.makeKeyAndVisible()
    }

    private func createDiscoveryVC() {
        guard var viewModel = container?.resolve(DiscoveryVMType.self),
            let discoveryVC = container?.resolve(DiscoveryVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
        viewModel.navigationDelegate = self
        self.discoveryVC = discoveryVC
    }
}

extension HomeCoordinator: DiscoveryViewModelNavigationDelegate {
 
    func mapButtonPressed(places: [PlaceInfo]) {
        guard let presntingVC = self.discoveryVC,
            let coordinator = container?.resolve(MapCoordinatorType.self, argument: presntingVC as UIViewController),
            let location = container?.resolve(LocationProviderType.self) else {
                                                    print("could not create MapCoordinator")
                                                    return
        }

        container?.register(MapVMType.self) { _ in
            MapVM(places: places, locationProvider: location)
        }

        container?.register(MapSearchVMType.self, factory: { _ in
            MapSearchVM(places: places)
        })

        coordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .map)
        }
        
        coordinator.start()
        add(coordinator: coordinator, for: .map)
    }
    
    func menuButtonPressed() {
        guard let presentingVC = self.discoveryVC,
            let coordinator = container?.resolve(LoginCoordinatorType.self, argument: presentingVC as UIViewController) else {
            print("could not create LoginCoordinator")
            return
        }

        coordinator.start()
        coordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .login)
        }
        presentingVC.hideTopBar()
        add(coordinator: coordinator, for: .login)
    }
    
    func placeCellDetailsPressed(_ place: PlaceInfo) {
        
        guard let presntingVC = self.discoveryVC,
            let placeProfileCoordinator = container?.resolve(PlaceProfileCoordinatorType.self, argument: presntingVC as UIViewController),
            place.profileVideoURL != nil  else {
                print("could not create placeProfileCoordinator")
                return
        }
        
        placeProfileCoordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .placeProfile)
        }
        
        container?.register(PlaceProfileVMType.self) { _ in
            PlaceProfileVM(placeInfo: place)
        }
        
        placeProfileCoordinator.start()
        add(coordinator: placeProfileCoordinator, for: .placeProfile)
    }
}
