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
    var tabsIconPadding: CGFloat { get }
    var viewControllers: [UIViewController]? { get }
    var discoveryVC: DiscoveryVC? { get }
    var conversationsVC: ConversationsVC? { get }
    var tabBarItems: [TabItem]? { get }
}

extension HomeCoordinatorType {
    var tabsIconPadding: CGFloat { return 10 }
    
    var discoveryVC: DiscoveryVC? {
        guard let viewModel = container?.resolve(DiscoveryViewModelType.self),
            let discoveryVC = container?.resolve(DiscoveryVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return nil
        }
        return discoveryVC
    }
    
    var conversationsVC: ConversationsVC? {
        guard let viewModel = container?.resolve(ConversationsViewModelType.self),
            let conversationsVC = container?.resolve(ConversationsVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return nil
        }
        return conversationsVC
    }

    var viewControllers: [UIViewController]? {
        if let discoveryVC = discoveryVC, let conversationsVC = conversationsVC {
            return [discoveryVC, conversationsVC]
        } else {
            return nil
        }
    }
        
    func start() {
        guard let viewControllers = viewControllers, let tapBarItems = tabBarItems else { return }
        tabBarController.viewControllers = viewControllers
        customizeTabButtonsAppearance(tapBarItems)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
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
