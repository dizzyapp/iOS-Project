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
    private var currentMediaView = UIView()
    private let swipesContainerView = UIView()
    private var placeProfileView = PlaceProfileView()
    private let closeButton = UIButton().navigaionCloseButton
    private let placeEventView = PlaceEventView()
    private let nextBackgroundImageButton = UIButton(frame: .zero)
    
    private let viewModel: PlaceProfileVMType
    
    let placeProfileViewCornerRadius = CGFloat(10)
    let placeProfileViewPadding = CGFloat(15)
    let placeProfileTopOffset = CGFloat(5)
    let placeProfileViewHeight = CGFloat(400)
    
    private var isFirstLoad = true

    init(viewModel: PlaceProfileVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        placeProfileView.configure(with: viewModel.placeInfo)
        placeProfileView.delegate = self
        addSubviews()
        layoutViews()
        setupView()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        view.backgroundColor = .black
        addSwipeListeners()
        setupPlaceProfileView()
        setupNavigation()
        setupLoadingView()
        setupNextBackgroundImageButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else {
            return
        }
        bindMediaViewToShow()
        isFirstLoad = false
    }
    
    private func addSwipeListeners() {
        let left = UISwipeGestureRecognizer(target : self, action : #selector(onLeftSwipe))
        left.direction = .left
        swipesContainerView.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(onRightSwipe))
        right.direction = .right
        swipesContainerView.addGestureRecognizer(right)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(onUpSwipe))
        swipeUp.direction = .up
        swipesContainerView.addGestureRecognizer(swipeUp)
        placeProfileView.addGestureRecognizer(swipeUp)
    }
    
    private func setupNavigation() {
        setupCloseButton()
        setupEventView()
    }
    
    private func setupNextBackgroundImageButton() {
        nextBackgroundImageButton.setImage(UIImage(named: "rightArrowIconWhite"), for: .normal)
        nextBackgroundImageButton.addTarget(self, action: #selector(onNextButtonPressed), for: .touchUpInside)
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setupEventView() {
        if let placeEventText = viewModel.getPlaceEvent() {
            placeEventView.setEventText(placeEventText)
        } else {
            placeEventView.isHidden = true
        }
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
        view.addSubviews([loadingView, swipesContainerView, placeProfileView, closeButton, placeEventView, nextBackgroundImageButton])
    }
    
    private func layoutViews() {
        
        nextBackgroundImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metrics.fiveTimesPadding)
            make.bottom.equalTo(placeProfileView.backgroundView.snp.top)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        placeEventView.snp.makeConstraints { placeEventView in
            placeEventView.centerY.equalTo(closeButton.snp.centerY)
            placeEventView.leading.equalToSuperview().offset(Metrics.doublePadding)
        }
        
        closeButton.snp.makeConstraints { closeButton in
            closeButton.top.equalTo(view.snp.topMargin).offset(Metrics.doublePadding)
            closeButton.trailing.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        loadingView.snp.makeConstraints { loadingView in
            loadingView.edges.equalToSuperview()
        }
        
        swipesContainerView.snp.makeConstraints { swipesContainerView in
            swipesContainerView.edges.equalToSuperview()
        }
        
        placeProfileView.snp.makeConstraints { placeProfileView in
            placeProfileView.top.equalTo(view.snp.bottom).inset(placeProfileViewHeight)
            placeProfileView.leading.equalToSuperview().offset(placeProfileViewPadding)
            placeProfileView.trailing.equalToSuperview().offset(-placeProfileViewPadding)
            placeProfileView.bottom.equalToSuperview().offset(-placeProfileViewPadding)
        }
    }
    
    private func bindMediaViewToShow() {
        viewModel.mediaViewToShow.bind(shouldObserveIntial: true) { [weak self] mediaViewToShow in
            guard let mediaViewToShow = mediaViewToShow else {
                return
            }
            self?.setNewMediaView(newMediaView: mediaViewToShow)
            self?.layoutCurrentMediaView()
            self?.playCurrentMediaView()
        }
    }
    
    private func bindViewModel() {
        viewModel.showNextArrow.bind { [weak self] show in
            self?.nextBackgroundImageButton.isHidden = !show
        }
    }
    
    private func setNewMediaView(newMediaView: UIView) {
        self.pauseCurrentMediaView()
        self.currentMediaView.removeFromSuperview()
        self.currentMediaView = newMediaView
    }
    
    private func layoutCurrentMediaView() {
        DispatchQueue.main.async {
            self.view.insertSubview(self.currentMediaView, at: 1)
            self.currentMediaView.snp.makeConstraints { currentMediaView in
                currentMediaView.edges.equalToSuperview()
            }
            self.currentMediaView.layoutIfNeeded()
        }
    }
    
    private func playCurrentMediaView() {
        if let videoView = currentMediaView as? VideoView {
            videoView.play()
        }
    }
    
    private func pauseCurrentMediaView() {
        if let videoView = currentMediaView as? VideoView {
            videoView.layoutIfNeeded()
            videoView.pause()
        }
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
    
    @objc func onUpSwipe() {
        viewModel.requestTableButtonPressed()
    }
    
    @objc private func onNextButtonPressed() {
        viewModel.onSwipeRight()
    }
}

extension PlaceProfileVC: PlaceProfileViewDelegate {
    func placeProfileViewGetTaxiButtonPressed(_ view: PlaceProfileView) {
        viewModel.getTaxiButtonPressed(view: view)
    }
    
    func placeProfileViewPlaceImagePressed(_ view: PlaceProfileView) {
        viewModel.placeImagePressed()
    }
    
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
    
    func placeProfileViewMenuButtonPressed(_ view: PlaceProfileView) {
        viewModel.delegate?.placeProfileMenuButtonPressed(viewModel, with: viewModel.placeInfo)
    }
}
