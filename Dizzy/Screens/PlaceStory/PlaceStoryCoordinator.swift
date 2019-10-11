//
//  PlaceStoryCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol PlaceStoryCoordinatorType: NavigationCoordinator {
    var onCoordinatorFinished: () -> Void { get set }
}

final class PlaceStoryCoordinator: PlaceStoryCoordinatorType {
    
    var onCoordinatorFinished: () -> Void = { }
    var navigationController = UINavigationController()
    var container: Container?
    var childCoordinators = [CoordinatorKey : Coordinator]()
    let presentingViewController: UIViewController
    
    init(container: Container?,
        presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
    }
    
    func start() {
        guard var viewModel = container?.resolve(PlaceStoryVMType.self),
            let placeStoryVC = container?.resolve(PlaceStoryVC.self, argument: viewModel) else {
                print("cannot load placeStoryVC")
                onCoordinatorFinished()
                return
        }
        viewModel.navigationDelegate = self
        let nvc = placeStoryVC.embdedInNavigationController().withTransparentStyle()
        nvc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController = nvc
        presentingViewController.present(nvc, animated: true)
    }
}

extension PlaceStoryCoordinator: PlaceStoryVMNavigationDelegate {
    func placeStoryVMDidFinised(_ viewModel: PlaceStoryVMType) {
        navigationController.dismiss(animated: true)
        onCoordinatorFinished()
    }
}
