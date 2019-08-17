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
import SnapKit

final class PlaceStoryVC: ViewController {
    
    let imageView = UIImageView()
    
    var commentsManager: CommentsManager?
    
    let rightGestureView = UIView()
    let leftGestureView = UIView()

    var viewModel: PlaceStoryVMType
    
    let gestureViewWidth = CGFloat(150)
    let topViewHeight = CGFloat(58)
    let commentTextFieldView = CommentTextFieldView()
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
        commentsManager = CommentsManager(parentView: UIView())
        commentsManager?.delegate = self
        commentsManager?.dataSource = self
        
        addSubviews()
        layoutViews()
        setupNavigation()
        setupViews()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewSafeAreaInsetsDidChange() {
    }
    
    private func addSubviews() {
        view.addSubviews([imageView, rightGestureView, leftGestureView, commentTextFieldView])
    }
    
    private func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rightGestureView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.width.equalTo(gestureViewWidth)
            make.height.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        leftGestureView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(gestureViewWidth)
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        commentTextFieldView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Metrics.doublePadding)
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
        setupCommentTextFieldView()
        setupCommentsManager()
    }
    
    private func setupGestureView() {
        rightGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))
        leftGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
    }
    
    private func setupCommentTextFieldView() {
        
    }

    private func setupCommentsManager() {
        commentsManager?.commentsTextFieldInputView.showTextField(false)
    }
    
    private func bindViewModel() {
        viewModel.currentImageURLString.bind { [weak self] urlString in
            guard let urlString = urlString else { return }
            self?.commentsManager?.commentsTextFieldInputView.resetManagerToInitialState()
            if let url = URL(string: urlString) {
                guard let self = self else { return }
                self.imageView.kf.cancelDownloadTask()
                self.imageView.kf.indicatorType = .activity
                self.commentsManager?.commentsTextFieldInputView.showTextField(false)
                self.imageView.kf.setImage(with: url) {[weak self] _ in
                    print(url)
                    self?.commentsManager?.commentsTextFieldInputView.showTextField(true)
                }
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
    
    func commentView(isHidden: Bool) { }
    
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
