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

final class PlaceProfileCoodinator: PlaceProfileCoordinatorType, ReserveTableDisplayer {
    
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
        navigationController.modalPresentationStyle = .fullScreen
        presentingVC?.present(navigationController, animated: true)
    }
    
    private func showUploadStory(with place: PlaceInfo) {
        guard let uploadStoryCoordinator = container?.resolve(UploadStoryCoordinatorType.self, argument: navigationController) else {
            print("could not create uploadStoryCoordinator")
            return
        }
        
        container?.register(UploadStoryVMType.self) { _ in
            UploadStoryVM(placeInfo: place)
        }
        
        uploadStoryCoordinator.onCoordinatorFinished = { [weak self] dismiss in
            self?.removeCoordinator(for: .uploadStory)
            if dismiss {
                self?.onCoordinatorFinished()
            }
        }
        
        uploadStoryCoordinator.start()
        add(coordinator: uploadStoryCoordinator, for: .uploadStory)
    }
}

extension PlaceProfileCoodinator: PlaceProfileVMDelegate, StoryCoordinatorOpener {
    func placeProfileVMRequestATableTapped(_ viewModel: PlaceProfileVMType, with place: PlaceInfo) {
        showReservation(with: place)
    }
    
    func placeProfileVMClosePressed(_ viewModel: PlaceProfileVMType) {
        presentingVC?.dismiss(animated: true)
        onCoordinatorFinished()
    }
    
    func placeProfileVMUploadStoryButtonPressed(_ viewModel: PlaceProfileVMType) {
        showUploadStory(with: viewModel.placeInfo)
    }
    
    func placeProfileVMPlaceImagePresset(placeInfo: PlaceInfo) {
        showPlaceStory(placeInfo: placeInfo, presentingVC: navigationController.viewControllers.last)
    }
    
    func placeProfileMenuButtonPressed(_ viewModel: PlaceProfileVMType, with place: PlaceInfo) {
        
        guard
            let viewModel = container?.resolve(PlaceMenuVMType.self, argument: place),
            let viewController = container?.resolve(PlaceMenuVC.self, argument: viewModel) else {
                print("Coul'd not load PlaceMenuVC")
                return
        }
        
        navigationController.viewControllers.first?.present(viewController, animated: true)
    }
    
}
