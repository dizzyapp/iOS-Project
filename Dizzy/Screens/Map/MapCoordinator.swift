//
//  MapCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol MapCoordinatorType: NavigationCoordinator, MapVMDelegate {
    var presentingViewController: UIViewController { get }
    var onCoordinatorFinished: () -> Void { get set }
}

extension MapCoordinatorType {
    
    func start() {
        guard var viewModel = container?.resolve(MapVMType.self),
            let googleMap = container?.resolve(GoogleMapType.self),
            let mapVC = container?.resolve(MapVC.self, arguments: viewModel, googleMap) else {
                print("could not create MapVC page")
                return
        }
        
        viewModel.delegate = self
        let navigationController = mapVC.embdedInNavigationController().withTransparentStyle()
        self.navigationController = navigationController
        presentingViewController.present(navigationController, animated: true)
    }
}

extension MapCoordinatorType {
    func closeButtonPressed() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.onCoordinatorFinished()
        }
    }
}

final class MapCoordinator: MapCoordinatorType {
    
    var navigationController: UINavigationController
    var container: Container?
    var childCoordinators: [CoordinatorKey : Coordinator] = [:]
    var presentingViewController: UIViewController
    
    var onCoordinatorFinished: () -> Void = { }

    init(container: Container,
         presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
        navigationController = UINavigationController()
    }
}
