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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addGestures()
        addSubviews()
        layoutViews()
        showSpinner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var gestureDelegate: PlayerVCDelegate?
    
    let rightGestureView = UIView()
    let leftGestureView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    private func addSubviews() {
        contentOverlayView?.addSubviews([rightGestureView, leftGestureView])
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
    }
    
    @objc func didTapRight() {
        gestureDelegate?.rightButtonPressed()
    }
    
    @objc func didTapLeft() {
        gestureDelegate?.leftButtonPressed()
    }
}
