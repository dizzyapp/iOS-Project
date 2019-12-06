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
    func cameraSessionContreollerSavedVideoTo(File url: URL)
}

final class CameraSessionController: NSObject {
    
    private var session = AVCaptureSession()
    private var stillImageOutput = AVCapturePhotoOutput()
    private let videoCaptureOutput = AVCaptureMovieFileOutput()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
   
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var audioRecorder  = AVCaptureDevice.default(for: AVMediaType.audio)
    private var currentInput: AVCaptureDeviceInput?
    private var isCameraOpen = false

    weak var delegate: CameraSessionControllerDelegate?
    
    override init() {
        super.init()
        setupCamera()
    }

    func openCamera() {
        if !isCameraOpen {
            setupSession()
            addInput()
            addOutputs()
            setupLayer()
            isCameraOpen = true
        }
    }
    
    func startCapturingVideo() {
        let tempFilePath = setupTempFilePathToSaveVideo()
        videoCaptureOutput.startRecording(to: tempFilePath, recordingDelegate: self)
    }
    
    func stopCapturingVideo() {
        videoCaptureOutput.stopRecording()
    }
    
    private func setupSession() {
        session.sessionPreset = .high
    }
    
    private func setupCamera() {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera], mediaType: .video, position: .unspecified)
        
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
        
        do {
            try addCameraInput()
            try addAudioInput()
            
        } catch let error as NSError {
            guard let errorEnum = AVError.Code(rawValue: error.code) else { return }
            delegate?.cameraSessionControllerFailed(self, with: errorEnum)
        }
    }
    
    private func addCameraInput() throws {
        guard let camera = currentCamera else { return }
        let cameraInput = try AVCaptureDeviceInput(device: camera)
        self.currentInput = cameraInput
        if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
        }
    }
    
    private func addAudioInput() throws {
        guard let audioRecorder = audioRecorder else { return }
        let audioInput = try AVCaptureDeviceInput(device: audioRecorder)
        if session.canAddInput(audioInput) {
            session.addInput(audioInput)
        }
    }
    
    private func addOutputs() {
        addStillImageOutput()
        addVideoOutput()
    }
    
    private func addStillImageOutput() {
        stillImageOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])])
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.isLivePhotoCaptureEnabled = stillImageOutput.isLivePhotoCaptureSupported
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
    }
    
    private func addVideoOutput() {
        if session.canAddOutput(videoCaptureOutput) {
            session.addOutput(videoCaptureOutput)
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
    
    private func setupTempFilePathToSaveVideo() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsURL.appendingPathComponent("tempMovie.mp4")
        if FileManager.default.fileExists(atPath: filePath.absoluteString) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                // exception while deleting old cached file
                // ignore error if any
            }
        }
        
        return filePath
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

extension CameraSessionController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("completed capturing video to file: \(outputFileURL)")
        delegate?.cameraSessionContreollerSavedVideoTo(File: outputFileURL)
    }
}
