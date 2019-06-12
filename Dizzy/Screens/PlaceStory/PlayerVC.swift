//
//  PlayerVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol PlayerVCDelegate: class {
    func rightButtonPressed()
    func leftButtonPressed()
    func playerVCSendPressed(_ playerVC: PlayerVC, with message: String)
}

final class PlayerVC: AVPlayerViewController, LoadingContainer {
    
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .whiteLarge)
    var commentsManager: CommentsManager?
    let viewModel: PlaceStoryVMType
    
    init(with url: URL, viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        player = AVPlayer(url: url)
        player?.currentItem?.audioTimePitchAlgorithm = .lowQualityZeroLatency
    
        if let contentOverlayView = contentOverlayView {
            commentsManager = CommentsManager(parentView: contentOverlayView)
            commentsManager?.delegate = self
            commentsManager?.dataSource = self
        }
        
        addGestures()
        addSubviews()
        layoutViews()
        showSpinner()
        setupNavigation()
        player?.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var gestureDelegate: PlayerVCDelegate?
    
    let rightGestureView = UIView()
    let leftGestureView = UIView()
    
    private func addSubviews() {
        contentOverlayView?.addSubviews([rightGestureView, leftGestureView])
        commentsManager?.addCommentsViews()
    }
    
    private func setupNavigation() {
        let closeButton = UIButton().smallRoundedBlackButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "backArrowIcon"), for: .normal)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeBarButton
    }

    private func layoutViews() {
        rightGestureView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(150)
            make.right.equalToSuperview()
        }
        
        leftGestureView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(150)
            make.left.equalToSuperview()
        }
    }
    
    private func addGestures() {
        rightGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))
        leftGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
        contentOverlayView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:))))
    }
    
    @objc func didTapRight() {
        gestureDelegate?.rightButtonPressed()
    }
    
    @objc func didTapLeft() {
        gestureDelegate?.leftButtonPressed()
    }
    
    @objc func longTap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            pause()
            
        case .ended:
            play()
            
        case .cancelled, .failed, .possible:
            break
        }
    }
    
    @objc func close() {
        
    }
    
    func pause() {
        player?.pause()
    }
    
    private func play() {
        player?.play()
    }
}

extension PlayerVC: CommentsManagerDelegate {
    
    func commentsManagerSendPressed(_ manager: CommentsManager, with message: String) {
        gestureDelegate?.playerVCSendPressed(self, with: message)
    }
    
    func commecntView(isHidden: Bool) {
        isHidden ? play() : pause()
    }
}

extension PlayerVC: CommentsManagerDataSource {
    func numberOfRowsInSection() -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func comment(at indexPath: IndexPath) -> Comment {
        return viewModel.comment(at: indexPath)
    }
}
