//
//  MediaPresenterVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class MediaPresenterVC: ViewController, LoadingContainer {
    
    private let cameraButtonHeight: CGFloat = 80
    private let buttonBottomPadding: CGFloat = 40

    private let viewModel: MediaPresenterVMType
    private let imageView = UIImageView()
    private let videoView = VideoView()
    private let cameraButton =  UIButton(frame: .zero)
    private let retakeButtom = UIButton(frame: .zero)
    private let placeIcon = PlaceImageView()
    private let loadingAnimation = DizzyLoadingView(backgroundColor: .white)
    
    private let borderRodius: CGFloat = 5.0
    
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .whiteLarge)

    init(viewModel: MediaPresenterVMType) {
        self.viewModel = viewModel
        super.init()
        buildView()
        buildConstraints()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMediaToShow()
    }
    
    private func setupViews() {
        stupNavigation()
        setupCameraButton()
        setupPlaceIcon()
        setupRetakeButton()
        hideMediaViews()
    }
    
    private func stupNavigation() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupRetakeButton() {
        retakeButtom.setTitle("Retake".localized, for: .normal)
        retakeButtom.showsTouchWhenHighlighted = true
        retakeButtom.setTitleColor(.white, for: .normal)
        retakeButtom.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
    }
    
    private func setupPlaceIcon() {
        guard let url = viewModel.placeIconURL else { return }
        placeIcon.setImage(from: url)
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
    
    private func hideMediaViews() {
        videoView.isHidden = true
        imageView.isHidden = true
    }
    
    private func showLoadingAnimation() {
        loadingAnimation.startLoadingAnimation()
        loadingAnimation.isHidden = false
    }
    
    private func hideLoadingAnimation() {
        loadingAnimation.stopLoadingAnimation()
        loadingAnimation.isHidden = true
    }
    
    private func setupMediaToShow() {
        switch viewModel.presentedMediaType {
        case .video(let videoURL):
            showVideo(videoLocalURL: videoURL)
        case .image(let image):
            showImage(image: image)
        }
        
        hideLoadingAnimation()
    }
    
    private func showVideo(videoLocalURL: URL) {
        imageView.isHidden = true
        videoView.isHidden = false
        videoView.configure(url: videoLocalURL)
        videoView.isLoop = true
        videoView.play()
    }
    
    private func showImage(image: UIImage) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.isHidden = false
        videoView.stop()
        videoView.isHidden = true
    }
    
    private func buildView() {
        view.addSubviews([imageView, videoView, placeIcon, retakeButtom, cameraButton, loadingAnimation])
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoView.snp.makeConstraints { videoView in
            videoView.edges.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints { make in
            make.height.width.equalTo(cameraButtonHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(buttonBottomPadding)
        }
        
        placeIcon.snp.makeConstraints { make in
            make.center.equalTo(cameraButton.snp.center)
            make.height.width.equalTo(cameraButtonHeight * 0.7)
        }
        
        retakeButtom.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton.snp.centerY)
            make.trailing.equalTo(cameraButton.snp.leading).inset(-Metrics.doublePadding)
        }
        
        loadingAnimation.snp.makeConstraints { loadingAnimation in
            loadingAnimation.edges.equalToSuperview()
        }
    }
    
    @objc private func backPressed() {
        viewModel.backPressed()
    }
    
    @objc private func uploadButtonTapped() {
        viewModel.uploadPressed()
    }
}
