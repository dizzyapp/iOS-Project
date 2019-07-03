//
//  CameraSessionController.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 18/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraSessionControllerDelegate: class {
    func cameraSessionControllerIsReady(_ controller: CameraSessionController, with layer: AVCaptureVideoPreviewLayer)
    func cameraSessionControllerFailed(_ controller: CameraSessionController, with error: AVError.Code)
    
    func cameraSessionControllerdidFinishProcessing(_ controller: CameraSessionController, image: UIImage)
}

final class CameraSessionController: NSObject {
    
    private var session = AVCaptureSession()
    private var stillImageOutput = AVCapturePhotoOutput()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
   
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var currentInput: AVCaptureDeviceInput?

    weak var delegate: CameraSessionControllerDelegate?
    
    override init() {
        super.init()
        setupCamera()
    }

    func openCamera() {
        setupSession()
        addInput()
        addOutput()
        setupLayer()
    }
    
    private func setupSession() {
        session.sessionPreset = .high
    }
    
    private func setupCamera() {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        for device in session.devices {
            if device.position == .front {
                frontCamera = device
            } else if device.position == .back {
                backCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    private func addInput() {
        guard let camera = currentCamera else { return }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            self.currentInput = input
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch let error as NSError {
            guard let errorEnum = AVError.Code(rawValue: error.code) else { return }
            delegate?.cameraSessionControllerFailed(self, with: errorEnum)
        }
    }
    
    private func addOutput() {
        stillImageOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])])
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.isLivePhotoCaptureEnabled = stillImageOutput.isLivePhotoCaptureSupported
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
    }
    
    private func setupLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        if let videoPreviewLayer = videoPreviewLayer {
            delegate?.cameraSessionControllerIsReady(self, with: videoPreviewLayer)
            session.startRunning()
        }
    }
    
    func takeShot() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 1800,
                             kCVPixelBufferHeightKey as String: 1800]
        settings.previewPhotoFormat = previewFormat
        
        settings.isHighResolutionPhotoEnabled = true
        settings.isAutoStillImageStabilizationEnabled = true
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func removeAllInputs() {
        guard let input = currentInput else { return }
        session.removeInput(input)
    }
    
    func switchCamera() {
        currentCamera = currentCamera == backCamera ? frontCamera : backCamera
        removeAllInputs()
        addInput()
    }
}

extension CameraSessionController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(),
            let imageView = UIImage(data: imageData),
            let cgImage = imageView.cgImage else {
            print("Error while generating image from photo capture data.")
            return
        }
        
        var orientation: UIImage.Orientation?
        if let postion = currentCamera?.position {
            orientation = postion == .back ? .right : .leftMirrored
        }
        
        let photo = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation ?? .right)
        delegate?.cameraSessionControllerdidFinishProcessing(self, image: photo)
    }
}