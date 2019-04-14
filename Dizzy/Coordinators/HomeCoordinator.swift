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
    var discoveryVC: DiscoveryVC? { get set }
    var conversationsVC: ConversationsVC? { get set }
    var tabBarItems: [TabItem]? { get }
}

extension HomeCoordinatorType {
    var tabsIconPadding: CGFloat { return Metrics.padding }
    
    var viewControllers: [UIViewController]? {
        guard let discoveryVC = discoveryVC, let conversationsVC = conversationsVC  else {
            return nil
        }
        return [discoveryVC, conversationsVC]
    }
     
    func start() {
        createViewControllers()
        guard let viewControllers = viewControllers, let tapBarItems = tabBarItems else { return }
        tabBarController.viewControllers = viewControllers
        customizeTabButtonsAppearance(tapBarItems)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    func createViewControllers() {
        createConversationsVC()
        createDiscoveryVC()
    }
    
    func createConversationsVC() {
        guard let viewModel = container?.resolve(ConversationsViewModelType.self),
            let conversationsVC = container?.resolve(ConversationsVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
        self.conversationsVC = conversationsVC
    }
    
    func createDiscoveryVC() {
        guard let viewModel = container?.resolve(DiscoveryViewModelType.self),
            let discoveryVC = container?.resolve(DiscoveryVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
        self.discoveryVC = discoveryVC
    }
}

class HomeCoordinator: HomeCoordinatorType {
    
    var discoveryVC: DiscoveryVC?
    var conversationsVC: ConversationsVC?
    var window: UIWindow
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    let tabBarController = UITabBarController()
    
    init(container: Container, window: UIWindow) {
        self.container = container
        self.window = window
    }
}
