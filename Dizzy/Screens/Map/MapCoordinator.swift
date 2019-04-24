//
//  MapCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol MapCoordinatorType: NavigationCoordinator {
    var presentingViewController: UIViewController { get }
    var onCoordinatorFinished: () -> Void { get set }
}

final class MapCoordinator: MapCoordinatorType {
    
    var navigationController: UINavigationController
    var container: Container?
    var childCoordinators: [CoordinatorKey : Coordinator] = [:]
    var presentingViewController: UIViewController
    
    private var mapViewModel: MapVMType?
    
    var onCoordinatorFinished: () -> Void = { }

    init(container: Container,
         presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
        navigationController = UINavigationController()
    }

    func start() {
        guard var viewModel = container?.resolve(MapVMType.self),
            let googleMap = container?.resolve(MapType.self),
            let mapVC = container?.resolve(MapVC.self, arguments: viewModel, googleMap) else {
                print("could not create MapVC page")
                return
        }
        
        self.mapViewModel = viewModel
        viewModel.delegate = self
        let navigationController = mapVC.embdedInNavigationController().withTransparentStyle()
        self.navigationController = navigationController
        presentingViewController.present(navigationController, animated: true)
    }
}

extension MapCoordinator: MapVMDelegate {
    func closeButtonPressed() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.onCoordinatorFinished()
        }
    }
    
    func searchButtonPressed() {
        guard var viewModel = container?.resolve(MapSearchVMType.self),
            let searchVC = container?.resolve(MapSearchVC.self, argument: viewModel) else {
                print("could not create MapSearchVC page")
                return
        }
        viewModel.delegate = self
        navigationController.pushViewController(searchVC, animationType: .fade)
    }
}

extension MapCoordinator: MapSearchVMDelegate {
   
    func didSelect(place: PlaceInfo) {
        mapViewModel?.didSelect(place: place)
        cancelButtonPressed()
    }
    
    func cancelButtonPressed() {
        navigationController.popViewController(with: .fade)
    }
}
