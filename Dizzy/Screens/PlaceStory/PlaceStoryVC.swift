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
    let rightGestureView = UIView()
    let leftGestureView = UIView()

    var viewModel: PlaceStoryVMType
    
    let gestureViewWidth = CGFloat(150)
    let topViewHeight = CGFloat(58)
    let commentTextFieldView = CommentTextFieldView()
    let commentsView = CommentsView()
    let bottomBackgroundView = UIView()
    
    var commentsViewTopConstraint: Constraint?
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
        addSubviews()
        layoutViews()
        setupViews()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentsViewTopConstraint?.update(offset: commentsView.frame.height - 20 )
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.commentsView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
    }
    
    private func addSubviews() {
        view.addSubviews([imageView, rightGestureView, leftGestureView, commentsView, commentTextFieldView, bottomBackgroundView])
    }
    
    private func layoutViews() {
        commentsView.snp.makeConstraints { commentsView in
            commentsView.leading.trailing.equalToSuperview()
            self.commentsViewTopConstraint = commentsView.top.equalTo(view.snp.topMargin).offset(Metrics.doublePadding).constraint
            commentsView.bottom.equalTo(commentTextFieldView.snp.top)
        }
                
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
        
        bottomBackgroundView.snp.makeConstraints { bottomBackgroundView in
            bottomBackgroundView.leading.trailing.bottom.equalToSuperview()
            bottomBackgroundView.top.equalTo(commentTextFieldView.snp.bottom)
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
        setupNavigation()
        setupBottomBackgroundView()
        setupGestureView()
        setupCommentsView()
    }
    
    private func setupCommentsView() {
        commentsView.dataSource = self
        commentsView.delegate = self
        commentsView.alpha = 0
    }
    
    private func setupGestureView() {
        rightGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))
        leftGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
    }
    
    private func setupBottomBackgroundView() {
        bottomBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    private func bindViewModel() {
        viewModel.currentImageURLString.bind { [weak self] urlString in
            guard let urlString = urlString else { return }
            if let url = URL(string: urlString) {
                guard let self = self else { return }
                self.imageView.kf.cancelDownloadTask()
                self.imageView.kf.indicatorType = .activity
                self.imageView.kf.setImage(with: url) {[weak self] _ in
                    print(url)
                }
            }
        }
        
        viewModel.comments.bind { [weak self] _ in
            self?.commentsView.reloadTableView()
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

extension PlaceStoryVC: CommentsViewDataSource {
    func numberOfRowsInSection() -> Int {
        return  viewModel.numberOfRowsInSection()
    }
    
    func comment(at indexPath: IndexPath) -> Comment? {
        return  viewModel.comment(at: indexPath)
    }
}

extension PlaceStoryVC: CommentsViewDelegate {
    func commentPressed() {
        
    }
    
    func hideCommentsPressed() {
        UIView.animate(withDuration: 1.0) {
            self.commentsViewTopConstraint?.update(offset: self.commentsView.frame.height - 20)
            self.view.layoutIfNeeded()
        }
        
    }
    
    func showCommentsPressed() {
        UIView.animate(withDuration: 1.0) {
            self.commentsViewTopConstraint?.update(offset: Metrics.doublePadding)
            self.view.layoutIfNeeded()
        }
    }
}
