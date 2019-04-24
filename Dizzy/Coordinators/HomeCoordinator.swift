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

class HomeCoordinator: HomeCoordinatorType, DiscoveryViewModelDelegate {
    
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
                print("could not create discovery page")
                return
        }
        self.conversationsVC = conversationsVC
    }
    
    private func createDiscoveryVC() {
        guard var viewModel = container?.resolve(DiscoveryViewModelType.self),
            let discoveryVC = container?.resolve(DiscoveryVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
        viewModel.delegate = self
        self.discoveryVC = discoveryVC
    }
}

extension HomeCoordinator {
    
    func mapButtonPressed() {
        guard let presntingVC = presentedViewControllers.first,
            let coordinator = container?.resolve(MapCoordinatorType.self, argument: presntingVC),
            let location = container?.resolve(LocationProviderType.self) else {
                                                    print("could not create MapCoordinator")
                                                    return
        }
        
        let places: [PlaceInfo] = [PlaceInfo(name: "name", address: "address", position: "position",
                                             location: Location(  latitude: 32.080481, longitude: 34.780527), imageURLString: "https://cdn.pixabay.com/photo/2018/08/14/13/23/ocean-3605547_960_720.jpg")]
        
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
    
    func menuButtonPressed() { }
}

extension HomeCoordinator {
    
    var discoveryTabBarItem: TabItem? {
        guard let discoveryVC = discoveryVC else { return nil }
        return TabItem(rootController: discoveryVC, icon: Images.discoverySelectedTabIcon(), iconSelected: Images.discoveryUnselectedTabIcon())
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
