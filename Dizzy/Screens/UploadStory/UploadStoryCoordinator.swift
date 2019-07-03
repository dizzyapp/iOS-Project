//
//  UploadStoryCoordinator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol UploadStoryCoordinatorType: NavigationCoordinator {
    var onCoordinatorFinished: (_ dismiss: Bool) -> Void { get set }
}

final class UploadStoryCoordinator: UploadStoryCoordinatorType {
    
    var onCoordinatorFinished: (_ dismiss: Bool) -> Void = { _ in }
    var navigationController: UINavigationController
    var container: Container?
    var childCoordinators: [CoordinatorKey : Coordinator] = [:]
    let placeInfo: PlaceInfo

    init(container: Container,
         navigationController: UINavigationController,
         placeInfo: PlaceInfo) {
        self.container = container
        self.navigationController = navigationController
        self.placeInfo = placeInfo
    }
    
    func start() {
        guard var uploadStoryVM = container?.resolve(UploadStoryVMType.self),
            let uploadStoryVC = container?.resolve(UploadStoryVC.self, argument: uploadStoryVM) else {
                print("cannot load uploadStoryVC")
                return
        }
        uploadStoryVM.delegate = self
        navigationController.pushViewController(uploadStoryVC, animated: true)
    }
    
    private func showPhotoPresenter(with photo: UIImage) {
        guard let uploadFileInteractor = container?.resolve(UploadFileInteractorType.self) else {
            print("cannot load uploadFileInteractor")
            return
        }
        
        container?.register(PhotoPresenterVMType.self) { _ in
            PhotoPresenterVM(photo: photo, uploadFileInteractor: uploadFileInteractor, placeInfo: self.placeInfo)
        }
        
        guard var photoPresenterVM = container?.resolve(PhotoPresenterVMType.self),
            let photoPresenterVC = container?.resolve(PhotoPresenterVC.self, argument: photoPresenterVM) else {
                print("Could not load photoPresenterVC")
                return
        }
        photoPresenterVM.delegate = self
        navigationController.pushViewController(photoPresenterVC, animated: false)
    }
}

extension UploadStoryCoordinator: UploadStoryVMDelegate {
    func uploadStoryVMBackPressed(_ viewModel: UploadStoryVMType) {
        navigationController.popViewController(animated: true)
        onCoordinatorFinished(false)
    }
    
    func uploadStoryVMdidFinishProcessing(_ viewModel: UploadStoryVMType, photo: UIImage) {
        showPhotoPresenter(with: photo)
    }
}

extension UploadStoryCoordinator: PhotoPresenterVMDelegate {
    func photoPresenterVMBackPressed(_ viewModel: PhotoPresenterVMType) {
        navigationController.popViewController(animated: true)
    }
    
    func photoPresenterVMUploadPressed(_ videwModel: PhotoPresenterVMType) {
        navigationController.dismiss(animated: true)
        onCoordinatorFinished(true)
    }
}
