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
    
    init(viewModel: PlaceProfileVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        if let url = URL(string: viewModel.placeInfo.profileVideoURL ?? "") {
            player = AVPlayer(url: url)
            makePlayerRepeat()
        }
        videoGravity = .resizeAspectFill
        placeProfileView.configure(with: viewModel.placeInfo)
        placeProfileView.delegate = self
        showsPlaybackControls = false
        addSubviews()
        setupNavigation()
        layoutSubview()
        NotificationCenter.default.addObserver(self, selector: #selector(onResineActive), name: UIApplication.willResignActiveNotification, object: nil)
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

    private func makePlayerRepeat() {
         playerItemDidPlayToEndObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) {
            [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    private func setupNavigation() {
        let closeButton = UIButton().smallRoundedBlackButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeBarButton
    }
    
    private func addSubviews() {
        contentOverlayView?.addSubviews([placeProfileView])
    }
    
    private func layoutSubview() {
        placeProfileView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
            make.leading.trailing.equalToSuperview().inset(Metrics.padding)
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
    func placeProfileViewWhatsappButtonPressed(_ view: PlaceProfileView) {
        viewModel.whatsappToPublicistPressed()
    }
    
    func placeProfileViewPublicistButtonPressed(_ view: PlaceProfileView) {
        viewModel.callToPublicistPressed()
    }
}
