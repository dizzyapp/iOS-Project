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
    private let cameraButton =  UIButton(frame: .zero)
    private let switchCameraButton = UIButton(frame: .zero)
    
    private let cameraButtonHeight: CGFloat = 80
    private let buttonBottomPadding: CGFloat = 40
    private let switchCameraPadding: CGFloat = 30
    
    private let borderRodius: CGFloat = 5.0
    
    init(viewModel: UploadStoryVMType) {
        self.viewModel = viewModel
        super.init()
        bindViewModel()
        viewModel.openCamera()
        buildView()
        buildConstraints()
        setupViews()
        setupNavigation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupCameraButton()
        setupSwitchCameraButton()
    }
    
    private func setupSwitchCameraButton() {
        switchCameraButton.setImage(UIImage(named: "switch_camera_icon"), for: .normal)
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonPressed), for: .touchUpInside)
    }

    private func setupCameraButton() {
        cameraButton.backgroundColor = .clear
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = borderRodius
        view.layoutIfNeeded()
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.captureVideoLayer.bind {                   [weak self] layer in
            guard let self = self, let layer = layer else { return }
            layer.frame = self.view.bounds
            self.view.layer.addSublayer(layer)
            self.view.bringSubviewToFront(self.cameraButton)
        }
        
        viewModel.errorString.bind { [weak self] errorString in
            self?.showPopup(with: "Dizzy".localized, message: errorString, buttonsLayer: .oneButton(buttonText: "Confirm".localized, onClick: {
                print("Clicked")
            }))
        }
    }
    
    private func buildView() {
        view.addSubviews([cameraButton, switchCameraButton])
    }
    
    private func buildConstraints() {
        cameraButton.snp.makeConstraints { make in
            make.height.width.equalTo(cameraButtonHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(buttonBottomPadding)
        }
        
        switchCameraButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton.snp.centerY)
            make.trailing.equalToSuperview().inset(switchCameraPadding)
        }
    }
    
    private func setupNavigation() {
        let backButton = UIButton().smallRoundedBlackButton
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
