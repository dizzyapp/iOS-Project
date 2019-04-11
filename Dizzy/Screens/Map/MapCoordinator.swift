//
//  MapCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol MapCoordinatorType: Coordinator {
    var markedPlaces: [PlaceInfo] { get }
    var presentingViewController: UIViewController { get }
}

extension MapCoordinatorType {
    
    func start() {
        guard let viewModel = container?.resolve(MapVMType.self),
            let mapVC = container?.resolve(MapVC.self, argument: viewModel) else {
                print("could not create discovery page")
                return
        }
    }
}

final class MapCoordinator: MapCoordinatorType {
    
    var container: Container?
    var childCoordinators: [CoordinatorKey : Coordinator] = [:]
    var markedPlaces: [PlaceInfo]
    var presentingViewController: UIViewController

    init(container: Container,
         markedPlaces: [PlaceInfo],
         presentingViewController: UIViewController) {
        self.container = container
        self.markedPlaces = markedPlaces
        self.presentingViewController = presentingViewController
    }
}
