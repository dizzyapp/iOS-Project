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
    
    let topView = UIView()
    let imageView = UIImageView()
    
    var commentsManager: CommentsManager?
    
    let rightGestureView = UIView()
    let leftGestureView = UIView()
    
    var viewModel: PlaceStoryVMType
    var playerVC: PlayerVC?
    
    let gestureViewWidth = CGFloat(150)
    let topViewHeight = CGFloat(58)
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
        commentsManager = CommentsManager(parentView: view)
        commentsManager?.delegate = self
        commentsManager?.dataSource = self
        addSubviews()
        layoutViews()
        setupNavigation()
        setupViews()

        bindViewModel()
        viewModel.showNextImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewSafeAreaInsetsDidChange() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(topViewHeight + view.safeAreaInsets.top)
        }
    }
    private func addSubviews() {
        view.addSubviews([imageView, topView, rightGestureView, leftGestureView])
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
    
    private func setupNavigation() {
        let closeButton = UIButton().smallRoundedBlackButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.setImage(Images.downArrowIcon(), for: .normal)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = closeBarButton
        
        self.title = self.viewModel.place.name
    }
    
    private func setupViews() {
        setupGestureView()
        setupTopView()
        setupCommentsManager()
    }
    
    private func setupGestureView() {
        rightGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))
        leftGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
    }
    
    private func setupTopView() {
        topView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    private func setupCommentsManager() {
        commentsManager?.showTextField(false)

    }
    
    private func bindViewModel() {
        viewModel.currentImageURLString.bind { [weak self] urlString in
            guard let urlString = urlString else { return }
            self?.commentsManager?.resetManagerToInitialState()
            if let url = URL(string: urlString) {
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

    @objc func didTapRight() {
        viewModel.showNextImage()
    }
    
    @objc func didTapLeft() {
        viewModel.showPrevImage()
    }
    
    @objc func close() {
        viewModel.close()
    }
}

extension PlaceStoryVC: CommentsManagerDelegate {
    
    func commecntView(isHidden: Bool) { }
    
    func commentsManagerSendPressed(_ manager: CommentsManager, with message: String) {
        let comment = Comment(id: UUID().uuidString, value: message, timeStamp: Date().timeIntervalSince1970)
        viewModel.send(comment: comment)
    }
}

extension PlaceStoryVC: CommentsManagerDataSource {
    func numberOfRowsInSection() -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func comment(at indexPath: IndexPath) -> Comment? {
        return viewModel.comment(at: indexPath)
    }
}
