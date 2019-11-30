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
        
        registerInteractors()

        registerViewModels()

        registerViewControllers()
        
        registerCoordinators()

        registerEntities()
    }
    
    func getAppCoordinator(window: UIWindow) -> AppCoordinator {
        return container.resolve(AppCoordinator.self, argument: window)!
    }

    func terminate() {
        self.container.removeAll()
    }

    private func registerInteractors() {
        container.autoregister(PlacesInteractorType.self, initializer: PlacesInteractor.init)
        container.autoregister(GooglePlaceInteractorType.self, initializer: GooglePlaceInteractor.init)
        container.autoregister(CommentsInteractorType.self, initializer: CommentsInteractor.init)
        container.autoregister(StoriesInteractorType.self, initializer: StoriesInteractor.init)
        container.autoregister(SignUpInteractorType.self, initializer: SignUpInteractor.init)
        container.autoregister(UploadFileInteractorType.self, initializer: UploadFileInteractor.init)
        container.autoregister(SignInInteractorType.self, initializer: SignInInteractor.init)
        container.autoregister(LogoutInteractorType.self, initializer: LogoutInteractor.init)
        container.autoregister(UsersInteracteorType.self, initializer: UsersInteracteor.init)
    }
    
    private func registerViewModels() {
        container.autoregister(DiscoveryVMType.self, initializer: DiscoveryVM.init)
        container.autoregister(ConversationsViewModelType.self, initializer: ConversationsViewModel.init)
        container.autoregister(LoginVMType.self, initializer: LoginVM.init)
        container.autoregister(SignUpWithDizzyVMType.self, initializer: SignUpWithDizzyVM.init)
        container.autoregister(SignInWithDizzyVMType.self, initializer: SignInWithDizzyVM.init)
        container.autoregister(AppStartVMType.self, initializer: AppStartVM.init).inObjectScope(.container)
        container.autoregister(AdminPlaceAnalyticsVMType.self, argument: PlaceInfo.self, initializer: AdminPlaceAnalyticsVM.init)
        container.autoregister(AdminPlacesVMType.self, initializer: AdminPlacesVM.init)
        container.autoregister(ReserveTableVMType.self, argument: PlaceInfo.self, initializer: ReserveTableVM.init)
    }
    
    private func registerViewControllers() {
        container.autoregister(DiscoveryVC.self, argument: DiscoveryVMType.self, initializer: DiscoveryVC.init)
        container.autoregister(ConversationsVC.self, argument: ConversationsViewModelType.self, initializer: ConversationsVC.init)
        container.autoregister(MapVC.self, arguments: MapVMType.self, MapType.self, initializer: MapVC.init)
        container.autoregister(PlaceStoryVC.self, argument: PlaceStoryVMType.self ,initializer: PlaceStoryVC.init)
        container.autoregister(PlaceSearchVC.self, argument: PlaceSearchVMType.self ,initializer: PlaceSearchVC.init)
        container.autoregister(LoginVC.self, argument:LoginVMType.self,  initializer: LoginVC.init)
        container.autoregister(PlaceProfileVC.self, argument: PlaceProfileVMType.self, initializer: PlaceProfileVC.init)
        container.autoregister(SignUpWithDizzyVC.self, argument: SignUpWithDizzyVMType.self, initializer: SignUpWithDizzyVC.init)
        container.autoregister(UploadStoryVC.self, argument: UploadStoryVMType.self, initializer: UploadStoryVC.init)
        container.autoregister(MediaPresenterVC.self, argument: MediaPresenterVMType.self, initializer: MediaPresenterVC.init)
        container.autoregister(SignInWithDizzyVC.self, argument: SignInWithDizzyVMType.self, initializer: SignInWithDizzyVC.init)
        container.autoregister(AdminPlacesVC.self, argument: AdminPlacesVMType.self, initializer: AdminPlacesVC.init)
        container.autoregister(AdminPlaceAnalyticsVC.self, argument: AdminPlaceAnalyticsVMType.self, initializer: AdminPlaceAnalyticsVC.init)
        container.autoregister(ReserveTableVC.self, argument: ReserveTableVMType.self,initializer: ReserveTableVC.init)
    }
    
    private func registerCoordinators() {
        container.autoregister(AppCoordinator.self, argument: UIWindow.self, initializer: AppCoordinator.init)
        container.autoregister(HomeCoordinatorType.self, argument: UIWindow.self, initializer: HomeCoordinator.init)
        container.autoregister(WebServiceDispatcherType.self, initializer: WebServiceDispatcher.init).inObjectScope(.container)
        container.autoregister(MapCoordinatorType.self, argument: UIViewController.self, initializer: MapCoordinator.init)
        container.autoregister(LoginCoordinatorType.self, arguments: UIViewController.self, [PlaceInfo].self, initializer: LoginCoordinator.init)
        container.autoregister(PlaceProfileCoordinatorType.self, argument: UIViewController.self, initializer: PlaceProfileCoodinator.init)
        container.autoregister(UploadStoryCoordinatorType.self, argument: UINavigationController.self, initializer: UploadStoryCoordinator.init)
        container.autoregister(PlaceStoryCoordinatorType.self, argument: UIViewController.self, initializer: PlaceStoryCoordinator.init)
        container.autoregister(SearchPlaceCoordinatorType.self, argument: UIViewController.self, initializer: SearchPlaceCoordinator.init)
        container.autoregister(AdminSettingsCoordinatorType.self, argument: UINavigationController.self, initializer: AdminSettingsCoordinator.init)
    }
    
    private func registerEntities() {
        container.autoregister(MapType.self, initializer: GoogleMap.init).inObjectScope(.container)
        container.autoregister(LocationProviderType.self, initializer: LocationProvider.init)
        container.autoregister(InputValidator.self, initializer: InputValidator.init)
        container.autoregister(MyUserDefaultsType.self, initializer: MyUserDefaults.init).inObjectScope(.container)
        container.autoregister(DizzyUser.self) {
            return DizzyUser.guestUser()
        }
        
        container.autoregister(ActivePlace.self) {
            return ActivePlace(activePlaceInfo: nil)
        }
    }
}
