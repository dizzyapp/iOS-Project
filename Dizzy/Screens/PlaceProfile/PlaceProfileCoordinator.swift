//
//  PlaceProfileCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol PlaceProfileCoordinatorType: NavigationCoordinator {
    var onCoordinatorFinished: () -> Void { get set }
}

final class PlaceProfileCoodinator: PlaceProfileCoordinatorType {
    
    var navigationController = UINavigationController()
    
    var container: Container?
    
    var childCoordinators: [CoordinatorKey : Coordinator] = [:]
    
    var presentingVC: UIViewController?
    
    var onCoordinatorFinished: () -> Void = { }
    
    init(container: Container, presentingVC: UIViewController) {
        self.container = container
        self.presentingVC = presentingVC
    }
    
    func start() {
        guard var viewModel = container?.resolve(PlaceProfileVMType.self),
            let placeProfileVC = container?.resolve(PlaceProfileVC.self, argument: viewModel) else {
                print("cannot load placeProfileVC")
                return
        }
        
        viewModel.delegate = self
        let nvc = placeProfileVC.embdedInNavigationController().withTransparentStyle()
        navigationController = nvc
        presentingVC?.present(navigationController, animated: true)
    }
}

extension PlaceProfileCoodinator: PlaceProfileVMDelegate {
    func placeProfileVMClosePressed(_ viewModel: PlaceProfileVMType) {
        presentingVC?.dismiss(animated: true)
        onCoordinatorFinished()
    }
}