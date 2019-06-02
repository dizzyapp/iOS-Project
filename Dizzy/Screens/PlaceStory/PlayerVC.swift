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
}

final class PlayerVC: AVPlayerViewController, LoadingContainer {
    
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .whiteLarge)
    var commentsManager: CommentsManager?
    
    init(with url: URL) {
        super.init(nibName: nil, bundle: nil)
        player = AVPlayer(url: url)
    
        if let contentOverlayView = contentOverlayView {
            commentsManager = CommentsManager(parentView: contentOverlayView)
            commentsManager?.delegate = self
        }
        
        addGestures()
        addSubviews()
        layoutViews()
        showSpinner()
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
    
    func pause() {
        player?.pause()
    }
    
    private func play() {
        player?.play()
    }
}

extension PlayerVC: CommentsManagerDelegate {
    func commecntView(isHidden: Bool) {
        isHidden ? play() : pause()
    }
}
