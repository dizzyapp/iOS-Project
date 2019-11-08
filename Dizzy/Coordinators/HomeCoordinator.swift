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
    private var tabsIconPadding: CGFloat { return Metrics.padding }
    private let tabBarController = UITabBarController()

    var window: UIWindow
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    
    private var presentedViewControllers: [UIViewController] {
        guard let discoveryVC = discoveryVC else {
            return []
        }
        return [discoveryVC]
    }
    
    init(container: Container, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        createDiscoveryVC()
        tabBarController.viewControllers = presentedViewControllers
        customizeTabButtonsAppearance(tabBarItems)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func createDiscoveryVC() {
        guard var viewModel = container?.resolve(DiscoveryVMType.self),
            let appStartViewModel = container?.resolve(AppStartVMType.self),
            let discoveryVC = container?.resolve(DiscoveryVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
        appStartViewModel.appUser.bind { [weak self] user in
            guard let user = user else {return}
            self?.container?.autoregister(DizzyUser.self, initializer: {return user})
        }
        viewModel.navigationDelegate = self
        self.discoveryVC = discoveryVC
    }
}

extension HomeCoordinator: DiscoveryViewModelNavigationDelegate {
    
    func activePlaceWasSet(_ activePlace: PlaceInfo?) {
        container?.autoregister(ActivePlace.self, initializer: {
            return ActivePlace(activePlaceInfo: activePlace)
        })
        
        if let activePlace = activePlace {
            placeCellDetailsPressed(activePlace)
        }
    }
  
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

        container?.register(PlaceSearchVMType.self, factory: { _ in
            PlaceSearchVM(places: places, locationProvider: location)
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
            let activePlace = container?.resolve(ActivePlace.self),
            let placesInteractor  = container?.resolve(PlacesInteractorType.self),
            let placeProfileCoordinator = container?.resolve(PlaceProfileCoordinatorType.self, argument: presntingVC as UIViewController)  else {
                print("could not create placeProfileCoordinator")
                return
        }
        
        placeProfileCoordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .placeProfile)
        }
        
        container?.register(PlaceProfileVMType.self) { _ in
            PlaceProfileVM(placeInfo: place, activePlace: activePlace, placesInteractor: placesInteractor)
        }
        
        placeProfileCoordinator.start()
        add(coordinator: placeProfileCoordinator, for: .placeProfile)
    }
    
    func placeCellIconPressed(_ place: PlaceInfo) {
        guard let presntingVC = presentedViewControllers.first,
            let placeStoryCoordinator = container?.resolve(PlaceStoryCoordinatorType.self, argument: presntingVC),
            let commentsInteractor = container?.resolve(CommentsInteractorType.self),
            let storiesInteractor = container?.resolve(StoriesInteractorType.self),
            let usersInteractor = container?.resolve(UsersInteracteorType.self),
            let user = container?.resolve(DizzyUser.self) else {
                print("could not create placeProfileCoordinator")
                return
        }
        
        container?.register(PlaceStoryVMType.self) { _ in
            PlaceStoryVM(place: place, commentsInteractor: commentsInteractor, storiesInteractor: storiesInteractor, user: user, usersInteractor: usersInteractor)
        }
        
        placeStoryCoordinator.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .placeStory)
        }
        
        placeStoryCoordinator.start()
        add(coordinator: placeStoryCoordinator, for: .placeStory)
    }
}

extension HomeCoordinator {
    var discoveryTabBarItem: TabItem? {
        guard let discoveryVC = discoveryVC else { return nil }
        return TabItem(rootController: discoveryVC, icon: Images.discoveryUnselectedTabIcon(), iconSelected: Images.discoverySelectedTabIcon())
    }
    
    var tabBarItems: [TabItem] {
        guard let discoveryTabBarItem = discoveryTabBarItem else { return [] }
        
        return [discoveryTabBarItem]
    }
    
    func customizeTabButtonsAppearance(_ tabItems: [TabItem]) {
        guard let tabBarItems = tabBarController.tabBar.items else {
            return
        }
        tabBarController.tabBar.isHidden = true
        for (index, tabBarItem) in tabBarItems.enumerated() {
            tabBarItem.image = tabItems[index].icon
            tabBarItem.selectedImage = tabItems[index].iconSelected
            tabBarItem.title = tabItems[index].title
            tabBarItem.imageInsets = UIEdgeInsets(top:  tabsIconPadding, left:  0, bottom: -tabsIconPadding, right: 0)
        }
    }
}
