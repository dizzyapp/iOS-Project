//
//  Assembly.swift
//  Dizzy
//
//  Created by Or Menashe on 30/03/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject
import SwinjectAutoregistration

protocol ContainerResolver {
    func resolve<T>(type: T.Type) -> T
    func terminate()
}

class Assembly {
    private let container = Container()

    public func registerDependencies() {
        self.container.register(Container.self) { [unowned self] _ in
            return self.container
        }
        // MARK: Interactors
        container.autoregister(PlacesInteractorType.self, initializer: PlacesInteractor.init)
        
        // MARK: view models
        container.autoregister(DiscoveryViewModelType.self, initializer: DiscoveryViewModel.init)
        container.autoregister(ConversationsViewModelType.self, initializer: ConversationsViewModel.init)
        
        // MARK: view controllers
        container.autoregister(DiscoveryVC.self, argument: DiscoveryViewModelType.self, initializer: DiscoveryVC.init)
        container.autoregister(ConversationsVC.self, argument: ConversationsViewModelType.self, initializer: ConversationsVC.init)
        container.autoregister(MapVC.self, arguments: MapVMType.self, GoogleMapType.self, initializer: MapVC.init)
        
        // MARK: coordinators
        container.autoregister(AppCoordinator.self, argument: UIWindow.self, initializer: AppCoordinator.init)
        container.autoregister(HomeCoordinatorType.self, argument: UIWindow.self, initializer: HomeCoordinator.init)
        container.autoregister(WebServiceDispatcherType.self, initializer: WebServiceDispatcher.init).inObjectScope(.container)
        container.autoregister(MapCoordinatorType.self, argument: UIViewController.self, initializer: MapCoordinator.init)

        // MARK: Entities:
        container.autoregister(GoogleMapType.self, initializer: GoogleMap.init).inObjectScope(.container)
        container.autoregister(LocationProviderType.self, initializer: LocationProvider.init)
    }
    
    func getAppCoordinator(window: UIWindow) -> AppCoordinator {
        return container.resolve(AppCoordinator.self, argument: window)!
    }

    func terminate() {
        self.container.removeAll()
    }

}
