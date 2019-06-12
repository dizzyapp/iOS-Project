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
    var placeStoryVM: PlaceStoryVMType?
    
    init(container: Container?,
        presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
    }
    
    func start() {
        guard var viewModel = container?.resolve(PlaceStoryVMType.self),
            let placeStoryVC = container?.resolve(PlaceStoryVC.self, argument: viewModel) else {
                print("cannot load placeStoryVC")
                return
        }
        viewModel.delegate = self
        placeStoryVM = viewModel
        let nvc = placeStoryVC.embdedInNavigationController().withTransparentStyle()
        navigationController = nvc
        presentingViewController.present(nvc, animated: true)
    }
    
    private func displayVideo(with urlString: String) {
        guard let url = URL(string: urlString), let viewModel = placeStoryVM else {
            print("Could not load the video file: \(urlString)")
            return
        }
        
        let playerVC = PlayerVC(with: url, viewModel: viewModel)
        playerVC.gestureDelegate = self
        playerVC.commentsDelegate = self
        navigationController.pushViewController(playerVC, animated: false)
    }
}

extension PlaceStoryCoordinator: PlaceStoryVMDelegate {
    func placeStoryShowVideo(_ viewModel: PlaceStoryVMType, stringURL: String) {
        displayVideo(with: stringURL)
    }
    
    func placeStoryVMDidFinised(_ viewModel: PlaceStoryVMType) {
        navigationController.dismiss(animated: true)
        onCoordinatorFinished()
    }
}

extension PlaceStoryCoordinator: PlayerVCGestureDelegate {
    func rightButtonPressed() {
        navigationController.popViewController(animated: false)
        placeStoryVM?.showNextImage()
    }
    
    func leftButtonPressed() {
        navigationController.popViewController(animated: false)
        placeStoryVM?.showPrevImage()
    }
}

extension PlaceStoryCoordinator: PlayerVCCommentsDelegate {
    func playerVCNumberOfSections(_ player: PlayerVC) -> Int {
        return placeStoryVM?.numberOfRowsInSection() ?? 0
    }
    
    func playerVCComment(_ player: PlayerVC, at indexPath: IndexPath) -> Comment? {
        return placeStoryVM?.comment(at: indexPath)
    }
    
    func playerVCSendPressed(_ playerVC: PlayerVC, with message: String) {
        let comment = Comment(value: message, timeStamp: Date().timeIntervalSince1970)
        placeStoryVM?.send(comment: comment)
    }
}
