//
//  AdminSettingCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol AdminSettingsCoordinatorType: NavigationCoordinator {
    var onAdminSettingsCoordinatorFinished: () -> Void { get set }
}

final class AdminSettingsCoordinator: AdminSettingsCoordinatorType {
    
    var onAdminSettingsCoordinatorFinished: () -> Void = { }
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    var navigationController: UINavigationController

    init(container: Container,
         navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        guard let adminPlacesVM = container?.resolve(AdminPlacesVMType.self),
            let adminPlaceVC = container?.resolve(AdminPlacesVC.self, argument: adminPlacesVM) else {
                print("could not load adminPlaceVC")
                return
        }
        
        navigationController.pushViewController(adminPlaceVC, animated: true)
    }
}
