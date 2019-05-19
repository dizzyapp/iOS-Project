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
    
    private var profileView: ProfileView = {
        let view = ProfileView()
        return view
    }()
    
    init(viewModel: PlaceProfileVMType) {
        super.init(nibName: nil, bundle: nil)
        if let url = URL(string: viewModel.placeInfo.profileVideoURL ?? "") {
            player = AVPlayer(url: url)
            makePlayerRepeat()
        }
        profileView.setupImageView(with: viewModel.placeInfo.imageURLString ?? "")
        showsPlaybackControls = false
        addSubviews()
        layoutSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let playerItemDidPlayToEndObserver = playerItemDidPlayToEndObserver {
            NotificationCenter.default.removeObserver(playerItemDidPlayToEndObserver)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    private func makePlayerRepeat() {
         playerItemDidPlayToEndObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) {
            [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    private func addSubviews() {
        contentOverlayView?.addSubviews([profileView])
    }
    
    private func layoutSubview() {
        profileView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
            make.leading.trailing.equalToSuperview().inset(Metrics.padding)
        }
    }
}
