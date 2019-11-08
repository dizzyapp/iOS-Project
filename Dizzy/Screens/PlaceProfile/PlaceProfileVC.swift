//
//  PlaceProfileVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 17/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import Kingfisher

final class PlaceProfileVC: UIViewController {
    private let loadingView = DizzyLoadingView()
    private let videoView = VideoView()
    private let imageView = UIImageView()
    private let swipesContainerView = UIView()
    private var placeProfileView = PlaceProfileView()
    
    private let viewModel: PlaceProfileVMType
    
    let placeProfileViewCornerRadius = CGFloat(8)
    let placeProfileViewPadding = CGFloat(8)
    let placeProfileTopOffset = CGFloat(5)
    
    private var isFirstLoad = true

    init(viewModel: PlaceProfileVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        placeProfileView.configure(with: viewModel.placeInfo)
        placeProfileView.delegate = self
        addSubviews()
        layoutViews()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = .black
        addSwipeListeners()
        setupPlaceProfileView()
        setupNavigation()
        setupImageView()
        setupVideoView()
        setupLoadingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else {
            return
        }
        bindViewModel()
        isFirstLoad = false
    }
    
    private func addSwipeListeners() {
        let left = UISwipeGestureRecognizer(target : self, action : #selector(onLeftSwipe))
        left.direction = .left
        swipesContainerView.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(onRightSwipe))
        right.direction = .right
        swipesContainerView.addGestureRecognizer(right)
    }
    
    private func setupNavigation() {
        let closeButton = UIButton().navigaionCloseButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    private func setupImageView() {
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setupVideoView() {
        videoView.isHidden = true
    }
    
    private func setupLoadingView() {
        loadingView.startLoadingAnimation()
    }
    
    private func setupPlaceProfileView() {
        if !viewModel.sholdShowStoryButton() {
            placeProfileView.hideStoryButton()
        }
    }
    
    private func addSubviews() {
        view.addSubviews([loadingView, imageView, videoView, swipesContainerView, placeProfileView])
    }
    
    private func layoutViews() {
        loadingView.snp.makeConstraints { loadingView in
            loadingView.edges.equalToSuperview()
        }
        
        videoView.snp.makeConstraints { videoView in
            videoView.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { imageView in
            imageView.edges.equalToSuperview()
        }
        
        swipesContainerView.snp.makeConstraints { swipesContainerView in
            swipesContainerView.edges.equalToSuperview()
        }
        
        placeProfileView.snp.makeConstraints { placeProfileView in
            placeProfileView.top.equalTo(view.snp.centerY).offset(Metrics.tinyPadding)
            placeProfileView.leading.equalToSuperview().offset(placeProfileViewPadding)
            placeProfileView.trailing.equalToSuperview().offset(-placeProfileViewPadding)
            placeProfileView.bottom.equalToSuperview().offset(-placeProfileViewPadding)
        }
    }
    
    private func bindViewModel() {
        viewModel.mediaToShow.bind(shouldObserveIntial: true) { [weak self] mediaToShow in
            guard let mediaToShow = mediaToShow,
            let downloadLink = mediaToShow.downloadLink else {
                return
            }
            
            if mediaToShow.isVideo() {
                self?.showVideo(videoUrlString: downloadLink)
            } else {
                self?.showImage(imageUrlString: downloadLink)
            }
            
        }
    }
    
    private func showVideo(videoUrlString: String) {
        guard let videoUrl = URL(string: videoUrlString) else {
            return
        }
        imageView.isHidden = true
        videoView.isHidden = false
        videoView.configure(url: videoUrl)
        videoView.play()
    }
    
    private func showImage(imageUrlString: String) {
        guard let imageUrl = URL(string: imageUrlString) else {
            return
        }
        videoView.stop()
        imageView.isHidden = false
        videoView.isHidden = true
        imageView.kf.setImage(with: imageUrl)
    }
    
    @objc func close() {
        viewModel.closePressed()
    }
    
    @objc func onLeftSwipe() {
        viewModel.onSwipeLeft()
    }
    
    @objc func onRightSwipe() {
        viewModel.onSwipeRight()
    }
}

extension PlaceProfileVC: PlaceProfileViewDelegate {
    func placeProfileViewAddressButtonPressed(_ view: PlaceProfileView) {
        viewModel.addressButtonPressed(view: view)
    }

    func placeProfileViewCallButtonPressed(_ view: PlaceProfileView) {
        viewModel.callButtonPressed()
    }

    func placeProfileViewStoryButtonPressed(_ view: PlaceProfileView) {
        viewModel.storyButtonPressed()
    }

    func placeProfileViewRequestTableButtonPressed(_ view: PlaceProfileView) {
        viewModel.requestTableButtonPressed()
    }
}
