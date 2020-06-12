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
    
    private let rightGestureView = UIView()
    private let leftGestureView = UIView()
    private let loadingView = DizzyLoadingView()

    private var viewModel: PlaceStoryVMType
    private let gestureViewWidth = CGFloat(150)
    private let commentTextFieldView = CommentTextFieldView()
    private let commentsView = CommentsView()
    private let bottomBackgroundView = UIView()
    private var commentsTextInputViewBottomConstraint: Constraint?
    private let commentsViewHeightRatio = CGFloat(0.382)
    
    private var currentPresentedMedia = UIView()
    private let timeLabel = UILabel()
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
        self.viewModel.delegate = self
        addSubviews()
        layoutViews()
        setupViews()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view.addSubviews([loadingView, timeLabel, rightGestureView, leftGestureView, commentsView, commentTextFieldView, bottomBackgroundView])
    }
    
    private func layoutViews() {
        commentsView.snp.makeConstraints { commentsView in
            commentsView.leading.trailing.equalToSuperview()
            commentsView.height.equalToSuperview().multipliedBy(commentsViewHeightRatio)
            commentsView.bottom.equalTo(commentTextFieldView.snp.top)
        }
        
        loadingView.snp.makeConstraints { loadingView in
            loadingView.edges.equalToSuperview()
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
        
        timeLabel.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(Metrics.doublePadding)
            make.centerX.equalToSuperview()
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
        setupTimeLabel()
        view.backgroundColor = .black
    }
    
    private func setupTimeLabel() {
        timeLabel.font = Fonts.h10()
        timeLabel.textColor = UIColor.white
    }
    
    private func setupLoadingView() {
        loadingView.startLoadingAnimation()
    }
    
    private func setupCommentsView() {
        commentsView.dataSource = self
        commentsView.delegate = self
    }
    
    private func setupGestureView() {
        rightGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRight)))
        leftGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeft)))
    }
    
    private func setupCommentsTextField() {
        commentTextFieldView.delegate = self
        if let userProfileUrl = viewModel.getUserImageUrl() {
            commentTextFieldView.setUserImage(fromUrl: userProfileUrl)
        }
    }
    
    private func setupBottomBackgroundView() {
        bottomBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    private func bindViewModel() {
        
        viewModel.comments.bind { [weak self] _ in
            self?.commentsView.reloadTableView()
        }
        
        viewModel.currentStory.bind { [weak self] story in
            guard let self = self, let timeStamp = story?.timeStamp else { return }
            let date = Date(timeIntervalSince1970: timeStamp)
            self.timeLabel.text = date.timeDescriptionFromNow
        }
    }
    
    private func closeKeyboard() {
        view.endEditing(true)
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardSize = keyboardFrame.size
        let keyboardHeight = keyboardSize.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.commentsTextInputViewBottomConstraint?.update(offset: -keyboardHeight )
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.commentsTextInputViewBottomConstraint?.update(offset: -Metrics.doublePadding)
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
        
    }
    
    func showCommentsPressed() {

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
    
    func placeStoryShowVideo(_ viewModel: PlaceStoryVMType, videoView: VideoView?) {
        guard let videoView = videoView else { return }
        setNewMediaToShow(videoView)
        layoutCurrentPresentedMedia()
        videoView.play { [weak self] in
            self?.didTapRight()
        }
    }
    
    func placeStoryShowImage(_ viewModel: PlaceStoryVMType, imageView: UIImageView?) {
        guard let imageView = imageView else {
            return
        }
        setNewMediaToShow(imageView)
        layoutCurrentPresentedMedia()
    }
    
    private func layoutCurrentPresentedMedia() {
        view.insertSubview(currentPresentedMedia, at: 1)
        currentPresentedMedia.snp.makeConstraints { (currentPresentedMedia) in
            currentPresentedMedia.edges.equalToSuperview()
        }
        currentPresentedMedia.layoutIfNeeded()
    }
    
    private func setNewMediaToShow(_ newMediaToShow: UIView) {
        currentPresentedMedia.removeFromSuperview()
        pauseCurrentMedia()
        currentPresentedMedia = newMediaToShow
    }
    
    private func pauseCurrentMedia() {
        guard let videoView = currentPresentedMedia as? VideoView else {return}
        videoView.pause()
    }
    
    func placeStoryClearTextFieldText(_ viewModel: PlaceStoryVMType) {
        self.commentTextFieldView.text = ""
    }
    
}
