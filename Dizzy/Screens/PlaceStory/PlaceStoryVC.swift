//
//  PlaceStoryVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 25/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher

final class PlaceStoryVC: ViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var commentsManager: CommentsManager?
    
    let rightGestureView = UIView()
    let leftGestureView = UIView()
    
    var viewModel: PlaceStoryVMType
    var playerVC: PlayerVC?
    
    let gestureViewWidth = CGFloat(150)
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
        commentsManager = CommentsManager(parentView: view)
        commentsManager?.delegate = self
        commentsManager?.dataSource = self
        addSubviews()
        layoutViews()
        bindViewModel()
        setupViews()
        viewModel.showNextImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        rightGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))
        leftGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
        commentsManager?.showTextField(false)
    }
    
    private func addSubviews() {
        view.addSubviews([imageView, rightGestureView, leftGestureView])
        commentsManager?.addCommentsViews()
    }
    
    private func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rightGestureView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(gestureViewWidth)
            make.right.equalToSuperview()
        }
        
        leftGestureView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(gestureViewWidth)
            make.left.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.currentImageURLString.bind { [weak self] urlString in
            guard let urlString = urlString else { return }
            self?.playerVC?.pause()
            if urlString.contains(".MOV") {
                self?.displayVideo(with: urlString)
            } else if  let url = URL(string: urlString) {
                guard let self = self else { return }
                self.imageView.kf.cancelDownloadTask()
                self.imageView.kf.indicatorType = .activity
                self.commentsManager?.showTextField(false)
                self.imageView.kf.setImage(with: url) { [weak self] _ in
                    self?.commentsManager?.showTextField(true)
                }
                
                self.playerVC?.dismiss(animated: false)
            }
        }
        
        viewModel.comments.bind { [weak self] _ in
            self?.commentsManager?.reloadTableView()
        }
    }
    
    private func displayVideo(with urlString: String) {
        
        guard let url = URL(string: urlString) else {
            print("Could not load the video file: \(urlString)")
            return
        }
        
        playerVC = PlayerVC(with: url)
        playerVC?.showsPlaybackControls = false
        playerVC?.gestureDelegate = self
        showPlayer()
    }
    
    private func showPlayer() {
        guard let playerVC = playerVC else { return }
        present(playerVC, animated: false)
    }

    @objc func didTapRight() {
        viewModel.showNextImage()
    }
    
    @objc func didTapLeft() {
        viewModel.showPrevImage()
    }
}

extension PlaceStoryVC: PlayerVCDelegate {
    func playerVCSendPressed(_ playerVC: PlayerVC, with message: String) {
        let comment = Comment(value: message)
        viewModel.send(comment: comment)
    }
    
    func rightButtonPressed() {
        didTapRight()
    }
    
    func leftButtonPressed() {
        didTapLeft()
    }
}

extension PlaceStoryVC: CommentsManagerDelegate {
    
    func commecntView(isHidden: Bool) { }
    
    func commentsManagerSendPressed(_ manager: CommentsManager, with message: String) {
        let comment = Comment(value: message)
        viewModel.send(comment: comment)
    }
}

extension PlaceStoryVC: CommentsManagerDataSource {
    func numberOfRowsInSection() -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func comment(at indexPath: IndexPath) -> Comment {
        return viewModel.comment(at: indexPath)
    }
}
