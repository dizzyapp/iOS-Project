//
//  SearchPlaceCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 06/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject

protocol SearchPlaceCoordinatorType: Coordinator {
    var delegate: SearchPlaceCoordinatorDelegate? { get set }
}

protocol SearchPlaceCoordinatorDelegate: class {
    func searchPlaceCoordinatorDidSelect(place: PlaceInfo)
    func searchPlaceCoordinatorDidCancel()
}

final class SearchPlaceCoordinator: SearchPlaceCoordinatorType {
    
    var onCoordinatorFinished: () -> Void = { }
    var presentingViewController: UIViewController
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    
    weak var delegate: SearchPlaceCoordinatorDelegate?

    init(container: Container,
         presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
    }
    
    func start() {
        guard var viewModel = container?.resolve(PlaceSearchVMType.self),
            let searchVC = container?.resolve(PlaceSearchVC.self, argument: viewModel) else {
                print("could not create PlaceSearchVC page")
                return
        }
        viewModel.delegate = self
        searchVC.modalPresentationStyle = .fullScreen
        
        presentingViewController.present(searchVC, animated: false)
        presentingViewController = searchVC
    }
}

extension SearchPlaceCoordinator: PlaceSearchVMDelegate, ReserveTableDisplayer {
    func showReservation(with place: PlaceInfo) {
        
        guard var viewModel = container?.resolve(ReserveTableVMType.self, argument: place),
            let viewController = container?.resolve(ReserveTableVC.self, argument: viewModel) else {
                print("could not load ReseveTableVC")
                return
        }

        viewModel.reserveTableFinished = {
            viewController.dismiss(animated: true)
        }
        
        presentingViewController.present(viewController, animated: true)
    }
    
    func didPressReserveATable(withPlaceInfo placeInfo: PlaceInfo) {
        showReservation(with: placeInfo)
    }
    
    func didSelect(place: PlaceInfo) {
        cancelButtonPressed()
        delegate?.searchPlaceCoordinatorDidSelect(place: place)
    }
    
    func cancelButtonPressed() {
        presentingViewController.dismiss(animated: false)
        delegate?.searchPlaceCoordinatorDidCancel()
    }
}
