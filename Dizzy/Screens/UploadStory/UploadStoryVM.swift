//
//  UploadStoryVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import AVFoundation

protocol UploadStoryVMType {
    var captureVideoLayer: Observable<AVCaptureVideoPreviewLayer?> { get }
    var errorString: Observable<String> { get }
    var delegate: UploadStoryVMDelegate? { get set }
    
    func takeShot()
    func startCapturingVideo()
    func stopCapturingVideo()
    func openCamera()
    func switchCamera()
    func backPressed()
}

protocol UploadStoryVMDelegate: class {
    func uploadStoryVMBackPressed(_ viewModel: UploadStoryVMType)
    func uploadStoryVMdidFinishProcessingPhoto(_ viewModel: UploadStoryVMType, photo: UIImage, placeInfo: PlaceInfo)
    func uploadStoryVMdidFinishProcessingVideo(_ viewModel: UploadStoryVMType, videoPathUrl: URL, placeInfo: PlaceInfo)
}

final class UploadStoryVM: UploadStoryVMType {
    
    private let cameraSessionController = CameraSessionController()
    private let placeInfo: PlaceInfo
    
    var errorString = Observable<String>("")
    var captureVideoLayer = Observable<AVCaptureVideoPreviewLayer?>(nil)
    
    weak var delegate: UploadStoryVMDelegate?
    
    init(placeInfo: PlaceInfo) {
        self.placeInfo = placeInfo
        setupCameraController()
    }
    
    private func setupCameraController() {
        cameraSessionController.delegate = self
    }
    
    func takeShot() {
        cameraSessionController.takeShot()
    }
    
    func openCamera() {
        cameraSessionController.openCamera()
    }
    
    func switchCamera() {
        cameraSessionController.switchCamera()
    }
    
    func backPressed() {
        delegate?.uploadStoryVMBackPressed(self)
    }
    
    func startCapturingVideo() {
        cameraSessionController.startCapturingVideo()
    }
    
    func stopCapturingVideo() {
        cameraSessionController.stopCapturingVideo()
    }
}

extension UploadStoryVM: CameraSessionControllerDelegate {
    func cameraSessionControllerIsReady(_ controller: CameraSessionController, with layer: AVCaptureVideoPreviewLayer) {
        captureVideoLayer.value = layer
    }
    
    func cameraSessionControllerFailed(_ controller: CameraSessionController, with error: AVError.Code) {
        let message: String
        
        switch error {
        case .applicationIsNotAuthorized:
            message = "The application is not authorized to play media.".localized
            
        case .applicationIsNotAuthorizedToUseDevice:
            message = "The user has denied this application permission for media capture.".localized
            
        case .contentIsNotAuthorized:
            message = "The user is not authorized to play the media.".localized
            
        default:
            message = "General Error".localized
        }
        errorString.value = message
    }
    
    func cameraSessionControllerdidFinishProcessing(_ controller: CameraSessionController, image: UIImage) {
        delegate?.uploadStoryVMdidFinishProcessingPhoto(self, photo: image, placeInfo: placeInfo)
    }
    
    func cameraSessionContreollerSavedVideoTo(File url: URL) {
        delegate?.uploadStoryVMdidFinishProcessingVideo(self, videoPathUrl: url, placeInfo: placeInfo)
    }
}
