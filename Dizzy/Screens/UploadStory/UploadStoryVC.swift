//
//  UploadStoryVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 18/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class UploadStoryVC: ViewController, PopupPresenter {
    
    private let viewModel: UploadStoryVMType
    private let recordingIndicator = UILabel(frame: .zero)
    private var recordingTimer: Timer?
    private let cameraButton =  UIButton(frame: .zero)
    private let switchCameraButton = UIButton(frame: .zero)
    private let cameraButtonBackground = UIView()
    
    private let cameraButtonHeight: CGFloat = 80
    private let buttonBottomPadding: CGFloat = 40
    private let switchCameraPadding: CGFloat = 30
    private let cameraButtonBackgroundStartHeight: CGFloat = 0
    private let cameraButtonBackgroundOnLongPressHeight: CGFloat = 120
    
    private let borderRodius: CGFloat = 5.0
    
    init(viewModel: UploadStoryVMType) {
        self.viewModel = viewModel
        super.init()
        bindViewModel()
        buildView()
        buildConstraints()
        setupViews()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.openCamera()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupRecordingIndicator()
        setupCameraButton()
        setupSwitchCameraButton()
        setupCameraButtonBackgroundAnimation()
    }
    
    private func setupRecordingIndicator() {
        recordingIndicator.alpha = 0
        recordingIndicator.text = "recording".localized
        recordingIndicator.textColor = .white
    }
    
    private func setupSwitchCameraButton() {
         switchCameraButton.setImage(UIImage(named: "switch_camera_icon"), for: .normal)
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonPressed), for: .touchUpInside)
    }
    
    private func setupCameraButtonBackgroundAnimation() {
        cameraButtonBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        cameraButtonBackground.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButtonBackground.isHidden = true
    }

    private func setupCameraButton() {
        cameraButton.backgroundColor = .clear
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = borderRodius
        view.layoutIfNeeded()
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        setupLongPressForCameraButton()
    }
    
    private func cameraButtonAnimationOnLongPress() {
        cameraButton.backgroundColor = .white
        cameraButtonBackground.isHidden = false

        UIView.animate(withDuration: 0.2) {
            self.cameraButtonBackground.snp.updateConstraints { make in
                make.height.width.equalTo(self.cameraButtonBackgroundOnLongPressHeight)
            }
            self.view.layoutIfNeeded()
            self.cameraButtonBackground.layer.cornerRadius = self.cameraButtonBackground.frame.height / 2
            self.view.layoutIfNeeded()
        }
    }
    
    private func returnCameraButtonToNormalStyle() {
        cameraButton.backgroundColor = .clear
        
        cameraButtonBackground.snp.updateConstraints { make in
            make.height.width.equalTo(cameraButtonBackgroundStartHeight)
        }
        cameraButtonBackground.isHidden = true
    }
    
    private func setupLongPressForCameraButton() {
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPress))
        cameraButton.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func onLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            cameraButtonAnimationOnLongPress()
            showRecordingIndicator()
            viewModel.startCapturingVideo()
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            returnCameraButtonToNormalStyle()
            viewModel.stopCapturingVideo()
            hideRecordingIndicator()
        }
    }
    
    private func showRecordingIndicator() {
        recordingIndicator.alpha = 1
        recordingTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeRecordingIndicatorVisability), userInfo: nil, repeats: true)
    }
    
    func hideRecordingIndicator() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        recordingIndicator.alpha = 0
    }
    
    @objc func changeRecordingIndicatorVisability() {
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let self = self else { return }
            self.recordingIndicator.alpha = 1 - self.recordingIndicator.alpha
            self.view.layoutIfNeeded()
        }
    }
    
    private func bindViewModel() {
        viewModel.captureVideoLayer.bind { [weak self] layer in
            guard let self = self, let layer = layer else { return }
            layer.frame = self.view.bounds
            self.view.layer.addSublayer(layer)
            self.view.bringSubviewToFront(self.recordingIndicator)
            self.view.bringSubviewToFront(self.cameraButtonBackground)
            self.view.bringSubviewToFront(self.cameraButton)
            self.view.bringSubviewToFront(self.switchCameraButton)
        }
        
        viewModel.errorString.bind { [weak self] errorString in
            let action = Action(title: "Confirm".localized) {
                print("Clicked")
            }
            
            self?.showPopup(with: "Dizzy".localized, message: errorString, actions: [action])
        }
    }
    
    private func buildView() {
        view.addSubviews([recordingIndicator, cameraButtonBackground, cameraButton, switchCameraButton])
    }
    
    private func buildConstraints() {
        recordingIndicator.snp.makeConstraints { recordingIndicator in
            recordingIndicator.top.equalTo(view.snp.topMargin)
            recordingIndicator.centerX.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints { make in
            make.height.width.equalTo(cameraButtonHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(buttonBottomPadding)
        }
        
        switchCameraButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton.snp.centerY)
            make.trailing.equalToSuperview().inset(switchCameraPadding)
        }
        
        cameraButtonBackground.snp.makeConstraints { make in
             make.height.width.equalTo(cameraButtonBackgroundStartHeight)
             make.center.equalTo(cameraButton)
         }
    }
    
    private func setupNavigation() {
        let backButton = UIButton(type: .system)
        backButton.setImage(Images.backArrowIcon(), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func backPressed() {
        viewModel.backPressed()
    }
    
    @objc private func cameraButtonPressed() {
        viewModel.takeShot()
    }
    
    @objc private func switchCameraButtonPressed() {
        viewModel.switchCamera()
    }
}
