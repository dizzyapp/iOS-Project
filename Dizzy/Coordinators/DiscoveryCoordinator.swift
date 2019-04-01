//
//  DiscoveryCoordinator.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject

protocol DiscoveryCoordinatorType: TabCoordinator {}

extension DiscoveryCoordinatorType {
    func start() {
        guard let viewModel = container?.resolve(DiscoveryViewModelType.self),
            let discoveryVC = container?.resolve(DiscoveryVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
        let navigationController = UINavigationController(rootViewController: discoveryVC)
        tabItem = TabItem(rootController: navigationController, title: "discovery")
    }
}

class DiscoveryCoordinator: DiscoveryCoordinatorType {
    var tabItem: TabItem?
    weak var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    
    init(container: Container) {
        self.container = container
    }
}
