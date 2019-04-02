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
    var tabBarController : UITabBarController { get }
}

extension HomeCoordinatorType {
    var tabsIconPadding: CGFloat { return 10 }
    
    func start() {
        let childCoordinators = startChildCoordinators()
        let tabItems = getTabItems(from: childCoordinators)
        
        tabBarController.viewControllers = tabItems.map { $0.rootController }
        customizeTabButtonsAppearance(tabItems)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func startChildCoordinators() -> [TabCoordinator] {
        guard let discoveryCoordinator = container?.resolve(DiscoveryCoordinatorType.self),
            let conversationsCoordinator = container?.resolve(ConversationsCoordinatorType.self) else {
                print("could not create discovery coordinator or conversations coordinator")
                return []
        }
        
        add(coordinator: discoveryCoordinator, for: .discovery)
        add(coordinator: conversationsCoordinator, for: .conversations)
        
        discoveryCoordinator.start()
        conversationsCoordinator.start()
        
        return [discoveryCoordinator, conversationsCoordinator]
    }
    
    private func getTabItems(from tabCoordinators: [TabCoordinator]) -> [TabItem] {
        var tabItems = [TabItem]()
        for tabCoordinator in tabCoordinators {
            if let tabItem = tabCoordinator.tabItem {
                tabItems.append(tabItem)
            } else {
                print("trying to get tab item that is nil from: \(tabCoordinator)")
            }
        }
        return tabItems
    }
    
    private func customizeTabButtonsAppearance(_ tabItems: [TabItem]) {
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

class HomeCoordinator: HomeCoordinatorType {
    
    var window: UIWindow
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    let tabBarController = UITabBarController()
    
    init(container: Container, window: UIWindow) {
        self.container = container
        self.window = window
    }
}
