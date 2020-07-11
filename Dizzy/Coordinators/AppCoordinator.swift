//
//  MainAppCoordinator.swift
//  Dizzy
//
//  Created by Or Menashe on 31/03/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject

class AppCoordinator: Coordinator {
    weak var container: Container?
    private var window: UIWindow
    var childCoordinators = [CoordinatorKey : Coordinator]()
    let pushNotificationsInteractor: PushNotificationsInteractorType
    
    init(container: Container, window: UIWindow, pushNotificationsInteractor: PushNotificationsInteractorType) {
        self.container = container
        self.window = window
        self.pushNotificationsInteractor = pushNotificationsInteractor
    }
    
    func start() {
        guard let homeCoordinator = container?.resolve(HomeCoordinatorType.self, argument: window) else {
            print("could not resolve homeCoordinator")
            return
        }
        
        homeCoordinator.start()
        add(coordinator: homeCoordinator, for: .home)
    }
}
