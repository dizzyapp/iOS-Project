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
    
    private var tabsIconPadding: CGFloat { return Metrics.padding }
    private var discoveryVC: DiscoveryVC?
    private var conversationsVC: ConversationsVC?
    private let tabBarController = UITabBarController()
    
    var window: UIWindow
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()

    private var presentedViewControllers: [UIViewController] {
        guard let discoveryVC = discoveryVC, let conversationsVC = conversationsVC  else {
            return []
        }
        return [discoveryVC, conversationsVC]
    }
    
    init(container: Container, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() {
        createViewControllers()
        guard !presentedViewControllers.isEmpty, !tabBarItems.isEmpty else { return }
        tabBarController.viewControllers = presentedViewControllers
        customizeTabButtonsAppearance(tabBarItems)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func createViewControllers() {
        createConversationsVC()
        createDiscoveryVC()
    }
    
    private func createConversationsVC() {
        guard let viewModel = container?.resolve(ConversationsViewModelType.self),
            let conversationsVC = container?.resolve(ConversationsVC.self, argument: viewModel) else {
                print("could not create conversations page")
                return
        }
        self.conversationsVC = conversationsVC
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
        guard let presntingVC = presentedViewControllers.first,
            let coordinator = container?.resolve(MapCoordinatorType.self, argument: presntingVC),
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
        let vcc = container?.resolve(LoginCoordinatorType.self, argument: discoveryVC! as UIViewController)!
        vcc?.start()
        vcc?.onCoordinatorFinished = { [weak self] in
            self?.removeCoordinator(for: .login)
        }
        discoveryVC?.hideTopBar()
        add(coordinator: vcc!, for: .login)
    }
    
    func placeCellDetailsPressed(_ place: PlaceInfo) {
        guard let presntingVC = presentedViewControllers.first,
            let placeProfileCoordinator = container?.resolve(PlaceProfileCoordinatorType.self, argument: presntingVC),
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
    
    func placeCellIconPressed(_ place: PlaceInfo) {
        guard let presntingVC = presentedViewControllers.first,
            let placeStoryCoordinator = container?.resolve(PlaceStoryCoordinatorType.self, argument: presntingVC),
            let commentsInteractor = container?.resolve(CommentsInteractorType.self),
            place.placesStories != nil else {
                print("could not create placeProfileCoordinator")
                return
        }
    
        container?.register(PlaceStoryVMType.self) { _ in
            PlaceStoryVM(place: place, commentsInteractor: commentsInteractor)
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
    
    var conversationsTapBarItem: TabItem? {
        guard let conversactionVC = conversationsVC else { return nil }
        return TabItem(rootController: conversactionVC, icon: Images.conversationsUnselectedTabIcon(), iconSelected: Images.conversationsSelectedTabIcon())
    }
    
    var tabBarItems: [TabItem] {
        guard let discoveryTabBarItem = discoveryTabBarItem,
            let conversationsTapBarItem = conversationsTapBarItem else { return [] }
        return [discoveryTabBarItem, conversationsTapBarItem]
    }
    
    func customizeTabButtonsAppearance(_ tabItems: [TabItem]) {
        guard let tabBarItems = tabBarController.tabBar.items else {
            return
        }
        
        for (index, tabBarItem) in tabBarItems.enumerated() {
            tabBarItem.image = tabItems[index].icon
            tabBarItem.selectedImage = tabItems[index].iconSelected
            tabBarItem.title = tabItems[index].title
            tabBarItem.imageInsets = UIEdgeInsets(top:  tabsIconPadding, left:  0, bottom: -tabsIconPadding, right: 0)
        }
    }
}
