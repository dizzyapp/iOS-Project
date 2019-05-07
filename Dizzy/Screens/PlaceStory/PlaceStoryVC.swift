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
    
    let chatTextField = CommentTextFieldView()
    let chatTextFieldAccessoryView = CommentTextFieldView()
    let commentsView = CommentsView()
    
    let rightGestureView = UIView()
    let leftGestureView = UIView()
    
    var viewModel: PlaceStoryVMType
    var playerVC: PlayerVC?
    
    init(viewModel: PlaceStoryVMType) {
        self.viewModel = viewModel
        super.init()
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
        chatTextFieldAccessoryView.textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        chatTextField.textField.delegate = self
        commentsView.delegate = self
        commentsView.isHidden = true
    }
    
    private func addSubviews() {
        view.addSubviews([imageView, rightGestureView, leftGestureView, chatTextField, commentsView])
    }
    
    private func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        chatTextField.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        commentsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override var inputAccessoryView: UIView? {
        chatTextFieldAccessoryView.frame = CGRect(x: 0, y: 0, width: chatTextField.frame.width, height: chatTextField.frame.height)
        commentsView.isHidden = false
        return chatTextFieldAccessoryView
    }
    
    private func bindViewModel() {
        viewModel.showImage = { [weak self] urlString in
            if urlString.contains(".mov") || urlString.contains(".mp4") {
                self?.displayVideo(with: urlString)
            } else if  let url = URL(string: urlString) {
                guard let self = self else { return }
                self.imageView.kf.indicatorType = .activity
                self.imageView.kf.setImage(with: url, options: [.scaleFactor(UIScreen.main.scale)])
                self.playerVC?.dismiss(animated: false)
            }
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
    func rightButtonPressed() {
        didTapRight()
    }
    
    func leftButtonPressed() {
        didTapLeft()
    }
}

extension PlaceStoryVC: UITextFieldDelegate {
    @objc func textFieldValueChanged() {
        chatTextField.textField.text = chatTextFieldAccessoryView.textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chatTextFieldAccessoryView.textField.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0)
    }
}

extension PlaceStoryVC: CommentsViewDelegate {
    func commentsViewPressed() {
        commentsView.isHidden = true
        chatTextFieldAccessoryView.textField.perform(#selector(resignFirstResponder), with: nil, afterDelay: 0)
        view.endEditing(true)
    }
}
