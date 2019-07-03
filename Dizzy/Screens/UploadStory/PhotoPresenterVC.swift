//
//  PhotoPresenterVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class PhotoPresenterVC: ViewController, LoadingContainer {
    
    private let cameraButtonHeight: CGFloat = 80
    private let buttonBottomPadding: CGFloat = 40

    private let viewModel: PhotoPresenterVMType
    private let imageView = UIImageView()
    private let cameraButton =  UIButton(frame: .zero)
    private let placeIcon = UIImageView(frame: .zero)
    
    private let borderRodius: CGFloat = 5.0
    
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .whiteLarge)

    init(viewModel: PhotoPresenterVMType) {
        self.viewModel = viewModel
        super.init()
        buildView()
        buildConstraints()
        bindViewModel()
        setupNavigation()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupImageView()
        setupCameraButton()
        setupPlaceIcon()
    }
    
    private func setupPlaceIcon() {
        placeIcon.kf.setImage(with: viewModel.placeIconURL)
        placeIcon.contentMode = .scaleAspectFit
    }
    
    private func setupCameraButton() {
        cameraButton.backgroundColor = .clear
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = borderRodius
        view.layoutIfNeeded()
        cameraButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = viewModel.photo
    }
    
    private func bindViewModel() {
        viewModel.loading.bind { [weak self] loading in
            loading ? self?.showSpinner() : self?.hideSpinner()
        }
    }
    
    private func buildView() {
        view.addSubviews([imageView, cameraButton, placeIcon])
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints { make in
            make.height.width.equalTo(cameraButtonHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(buttonBottomPadding)
        }
        
        placeIcon.snp.makeConstraints { make in
            make.center.equalTo(cameraButton.snp.center)
            make.height.width.equalTo(cameraButtonHeight / 2)
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
    
    @objc private func uploadButtonTapped() {
        viewModel.uploadImageTapped()
    }
}
