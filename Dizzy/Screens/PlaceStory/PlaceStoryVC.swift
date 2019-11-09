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
    let videoView = VideoView()
    let rightGestureView = UIView()
    let leftGestureView = UIView()
    let loadingView = DizzyLoadingView()

    var viewModel: PlaceStoryVMType
    
    let gestureViewWidth = CGFloat(150)
    let commentTextFieldView = CommentTextFieldView()
    let commentsView = CommentsView()
    let bottomBackgroundView = UIView()
    
    var commentsViewTopConstraint: Constraint?
    var commentsTextInputViewBottomConstraint: Constraint?
    let commentsViewTopOffset: CGFloat = 10
    var areCommentsVisible = false
    var isKeyboardOpen = false
    var bottomBarHeight: CGFloat = 0
    var isFirstLoad = true
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
        self.viewModel.delegate = self
        addSubviews()
        layoutViews()
        setupViews()
        bindViewModel()
        view.backgroundColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else {
            return
        }
        commentsViewTopConstraint?.update(offset: commentsView.frame.height - commentsViewTopOffset )
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15) {
            self.commentsView.alpha = 1
            self.commentTextFieldView.alpha = 1
            self.bottomBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        if #available(iOS 11.0, *) {
            bottomBarHeight = view.safeAreaInsets.bottom
        }
        
        isFirstLoad = false
    }
    
    private func addSubviews() {
        view.addSubviews([loadingView, imageView, videoView, rightGestureView, leftGestureView, commentsView, commentTextFieldView, bottomBackgroundView])
    }
    
    private func layoutViews() {
        commentsView.snp.makeConstraints { commentsView in
            commentsView.leading.trailing.equalToSuperview()
            self.commentsViewTopConstraint = commentsView.top.equalTo(view.snp.topMargin).offset(Metrics.doublePadding).constraint
            commentsView.bottom.equalTo(commentTextFieldView.snp.top)
        }
        
        loadingView.snp.makeConstraints { loadingView in
            loadingView.edges.equalToSuperview()
        }
                
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoView.snp.makeConstraints { videoView in
            videoView.edges.equalToSuperview()
        }
        
        rightGestureView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.width.equalTo(gestureViewWidth)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        leftGestureView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(gestureViewWidth)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        commentTextFieldView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            commentsTextInputViewBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Metrics.doublePadding).constraint
        }
        
        bottomBackgroundView.snp.makeConstraints { bottomBackgroundView in
            bottomBackgroundView.leading.trailing.bottom.equalToSuperview()
            bottomBackgroundView.top.equalTo(commentTextFieldView.snp.bottom)
        }
    }
    
    private func setupNavigation() {
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.setImage(Images.exitStoryButton(), for: .normal)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = closeBarButton
        
        self.title = self.viewModel.place.name
    }
    
    private func setupViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupNavigation()
        setupLoadingView()
        setupBottomBackgroundView()
        setupGestureView()
        setupCommentsView()
        setupCommentsTextField()
    }
    
    private func setupLoadingView() {
        loadingView.startLoadingAnimation()
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
    
    private func setupCommentsTextField() {
        commentTextFieldView.delegate = self
        commentTextFieldView.alpha = 0
    }
    
    private func setupBottomBackgroundView() {
        bottomBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        bottomBackgroundView.alpha = 0
    }
    
    private func bindViewModel() {
        viewModel.currentImageURLString.bind { [weak self] urlString in
            guard let urlString = urlString else { return }
            if let url = URL(string: urlString) {
                guard let self = self else { return }
                self.shoewImageView()
                self.imageView.kf.cancelDownloadTask()
                self.imageView.kf.setImage(with: url)
            }
        }
        
        viewModel.comments.bind { [weak self] _ in
            self?.commentsView.reloadTableView()
        }
    }
    
    private func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func shoewImageView() {
        self.imageView.isHidden = false
        self.videoView.isHidden = true
        self.videoView.stop()
    }
    
    @objc func didTapRight() {
        closeKeyboard()
        viewModel.showNextImage()
    }
    
    @objc func didTapLeft() {
        closeKeyboard()
        viewModel.showPrevImage()
    }
    
    @objc func close() {
        viewModel.close()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard !isKeyboardOpen,
            let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardSize.height
        isKeyboardOpen = true
        let bottomViewHeight = self.bottomBackgroundView.bounds.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.updateCommentsViewTopConstraint(ByKeyboardHeight: keyboardHeight - bottomViewHeight)
            self?.commentsTextInputViewBottomConstraint?.update(offset: -Metrics.doublePadding - keyboardHeight + bottomViewHeight )
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard isKeyboardOpen,
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardSize.height
        let bottomSpace = bottomBarHeight + Metrics.doublePadding
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.updateCommentsViewTopConstraint(ByKeyboardHeight: -keyboardHeight + bottomSpace)
            self?.commentsTextInputViewBottomConstraint?.update(offset: -Metrics.doublePadding)
        }
        isKeyboardOpen = false
    }
    
    private func updateCommentsViewTopConstraint(ByKeyboardHeight keyboardHeight: CGFloat) {
        if !areCommentsVisible {
            let currentOffset = commentsViewTopConstraint?.layoutConstraints[0].constant ?? 0
            commentsViewTopConstraint?.update(offset: currentOffset - keyboardHeight)
        }
    }
}

extension PlaceStoryVC: CommentsViewDataSource {
    func numberOfRowsInSection() -> Int {
        return  viewModel.numberOfRowsInSection()
    }
    
    func comment(at indexPath: IndexPath) -> CommentWithWriter? {
        return  viewModel.comment(at: indexPath)
    }
}

extension PlaceStoryVC: CommentsViewDelegate {
    func commentPressed() {
        
    }
    
    func hideCommentsPressed() {
        areCommentsVisible = false
        UIView.animate(withDuration: 1.0) {
            self.commentsViewTopConstraint?.update(offset: self.commentsView.frame.height - self.commentsViewTopOffset)
            self.view.layoutIfNeeded()
        }
        
    }
    
    func showCommentsPressed() {
        areCommentsVisible = true
        UIView.animate(withDuration: 1.0) {
            self.commentsViewTopConstraint?.update(offset: Metrics.doublePadding)
            self.view.layoutIfNeeded()
        }
    }
}

extension PlaceStoryVC: CommentTextFieldViewDelegate {
    func commentTextFieldViewSendPressed(_ view: UIView, with message: String) {
        viewModel.send(message: message)
    }
}

extension PlaceStoryVC: PlaceStoryVMDelegate, PopupPresenter {
    func showPopupWithText(_ text: String, title: String) {
        closeKeyboard()
        let action = Action(title: "Ok".localized)
        showPopup(with: title, message: text, actions: [action])
    }
    
    func placeStoryShowVideo(_ viewModel: PlaceStoryVMType, stringURL: String) {
        guard let videoUrl = URL(string: stringURL) else { return }
        self.showVideoView()
        videoView.configure(url: videoUrl)
        videoView.play { [weak self] in
            self?.didTapRight()
        }
    }
    
    private func showVideoView() {
        videoView.isHidden = false
        imageView.isHidden = true
    }
    
    func placeStoryClearTextFieldText(_ viewModel: PlaceStoryVMType) {
        self.commentTextFieldView.text = ""
    }
    
}
