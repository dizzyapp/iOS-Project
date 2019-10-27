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

final class PlaceProfileVC: AVPlayerViewController {
    
    private var playerItemDidPlayToEndObserver: NSObjectProtocol?
    
    private var placeProfileView = PlaceProfileView()
    
    private let viewModel: PlaceProfileVMType
    
    let placeProfileViewCornerRadius = CGFloat(8)
    let placeProfileViewPadding = CGFloat(8)
    let placeProfileTopOffset = CGFloat(5)

    init(viewModel: PlaceProfileVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        loadVideo()
        placeProfileView.configure(with: viewModel.placeInfo)
        placeProfileView.delegate = self
        addSubviews()
        setupNavigation()
        layoutSubview()
        setupView()
        view.backgroundColor = .white
        player?.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let playerItemDidPlayToEndObserver = playerItemDidPlayToEndObserver {
          NotificationCenter.default.removeObserver(playerItemDidPlayToEndObserver)
        }
    }
    
    private func loadVideo() {
        if let url = URL(string: viewModel.placeInfo.profileVideoURL ?? "") {
            player = AVPlayer(url: url)
            makePlayerRepeat()
        }
    }
    
    private func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(onResineActive), name: UIApplication.willResignActiveNotification, object: nil)
        showsPlaybackControls = false
        videoGravity = .resizeAspectFill
        
        if !viewModel.sholdShowStoryButton() {
            placeProfileView.hideStoryButton()
        }
        
    }

    private func makePlayerRepeat() {
        
         playerItemDidPlayToEndObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) {
            [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    private func setupNavigation() {
        let closeButton = UIButton().navigaionCloseButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    private func addSubviews() {
        contentOverlayView?.addSubviews([placeProfileView])
    }
    
    private func layoutSubview() {
        
        placeProfileView.snp.makeConstraints { placeProfileView in
            placeProfileView.top.equalTo(contentOverlayView!.snp.centerY).offset(Metrics.tinyPadding)
            placeProfileView.leading.equalToSuperview().offset(placeProfileViewPadding)
            placeProfileView.trailing.equalToSuperview().offset(-placeProfileViewPadding)
            placeProfileView.bottom.equalToSuperview().offset(-placeProfileViewPadding)
        }
    }
    
    @objc func close() {
        viewModel.closePressed()
    }

    @objc private func onResineActive() {
        let isPlaying = player?.rate != 0 && player?.error == nil
        if isPlaying == false {
            player?.play()
        }
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
