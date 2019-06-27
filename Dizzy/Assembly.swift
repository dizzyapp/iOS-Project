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
        container.autoregister(GooglePlaceInteractorType.self, initializer: GooglePlaceInteractor.init)
        container.autoregister(SignUpInteractorType.self, initializer: SignUpInteractor.init)
        container.autoregister(SignInInteractorType.self, initializer: SignInInteractor.init)
        container.autoregister(LogoutInteractorType.self, initializer: LogoutInteractor.init)

        // MARK: view models
        container.autoregister(DiscoveryVMType.self, initializer: DiscoveryVM.init)
        container.autoregister(ConversationsViewModelType.self, initializer: ConversationsViewModel.init)
        container.autoregister(LoginVMType.self, initializer: LoginVM.init)
        container.autoregister(SignUpWithDizzyVMType.self, initializer: SignUpWithDizzyVM.init)
        container.autoregister(SignInWithDizzyVMType.self, initializer: SignInWithDizzyVM.init)

        // MARK: view controllers
        container.autoregister(DiscoveryVC.self, argument: DiscoveryVMType.self, initializer: DiscoveryVC.init)
        container.autoregister(ConversationsVC.self, argument: ConversationsViewModelType.self, initializer: ConversationsVC.init)
        container.autoregister(MapVC.self, arguments: MapVMType.self, MapType.self, initializer: MapVC.init)
        container.autoregister(PlaceStoryVC.self, argument: PlaceStoryVMType.self ,initializer: PlaceStoryVC.init)
        container.autoregister(MapVC.self, arguments: MapVMType.self, MapType.self, initializer: MapVC.init)
        container.autoregister(MapSearchVC.self, argument: MapSearchVMType.self ,initializer: MapSearchVC.init)
        container.autoregister(LoginVC.self, argument:LoginVMType.self,  initializer: LoginVC.init)
        container.autoregister(PlaceProfileVC.self, argument: PlaceProfileVMType.self, initializer: PlaceProfileVC.init)
        container.autoregister(SignUpWithDizzyVC.self, argument: SignUpWithDizzyVMType.self, initializer: SignUpWithDizzyVC.init)
        container.autoregister(SignInWithDizzyVC.self, argument: SignInWithDizzyVMType.self, initializer: SignInWithDizzyVC.init)

        // MARK: coordinators
        container.autoregister(AppCoordinator.self, argument: UIWindow.self, initializer: AppCoordinator.init)
        container.autoregister(HomeCoordinatorType.self, argument: UIWindow.self, initializer: HomeCoordinator.init)
        container.autoregister(WebServiceDispatcherType.self, initializer: WebServiceDispatcher.init).inObjectScope(.container)
        container.autoregister(MapCoordinatorType.self, argument: UIViewController.self, initializer: MapCoordinator.init)
        container.autoregister(LoginCoordinatorType.self, argument: UIViewController.self, initializer: LoginCoordinator.init)
        container.autoregister(PlaceProfileCoordinatorType.self, argument: UIViewController.self, initializer: PlaceProfileCoodinator.init)

        // MARK: Entities:
        container.autoregister(MapType.self, initializer: GoogleMap.init).inObjectScope(.container)
        container.autoregister(LocationProviderType.self, initializer: LocationProvider.init)
        container.autoregister(InputValidator.self, initializer: InputValidator.init)
    }
    
    func getAppCoordinator(window: UIWindow) -> AppCoordinator {
        return container.resolve(AppCoordinator.self, argument: window)!
    }

    func terminate() {
        self.container.removeAll()
    }

}
