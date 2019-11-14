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
    
    var initialNumberOfVCs = 0

    init(container: Container,
         navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        initialNumberOfVCs = navigationController.viewControllers.count
    }
    
    func start() {
        guard var adminPlacesVM = container?.resolve(AdminPlacesVMType.self),
            let adminPlaceVC = container?.resolve(AdminPlacesVC.self, argument: adminPlacesVM) else {
                print("could not load adminPlaceVC")
                return
        }
        
        adminPlacesVM.delegate = self
        navigationController.pushViewController(adminPlaceVC, animated: true)
    }
    
    private func showPlaceAnalytics(_ place: PlaceInfo) {
        guard var adminPlaceAnalyticsVM = container?.resolve(AdminPlaceAnalyticsVMType.self, argument: place),
            let adminPlaceAnalyticsVC = container?.resolve(AdminPlaceAnalyticsVC.self, argument: adminPlaceAnalyticsVM) else {
                print("could not load adminPlaceAnalyticsVC")
                return
        }
        adminPlaceAnalyticsVM.delegate = self
        navigationController.pushViewController(adminPlaceAnalyticsVC, animated: true)
    }
    
    private func popVCAndFinisheCoordinatorIfNeeded() {
        navigationController.popViewController(animated: true)
        let currentNumberOfVCs = navigationController.viewControllers.count
        let shouldFinishCoordinator = currentNumberOfVCs == initialNumberOfVCs
        
        if shouldFinishCoordinator {
            onAdminSettingsCoordinatorFinished()
        }
    }
}

extension AdminSettingsCoordinator: AdminPlacesVMDelegate {

    func adminPlaceVMBackPressed(_ viewModel: AdminPlacesVMType) {
        popVCAndFinisheCoordinatorIfNeeded()
    }
    
    func adminPlaceVM(_ viewModel: AdminPlacesVMType, didSelectPlace place: PlaceInfo) {
        showPlaceAnalytics(place)
    }
}

extension AdminSettingsCoordinator: AdminPlaceAnalyticsVMDelegate {
    
    func adminPlaceAnalyticsBackPressed(_ viewModel: AdminPlaceAnalyticsVMType) {
        popVCAndFinisheCoordinatorIfNeeded()
    }
}
