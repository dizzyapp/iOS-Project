//
//  DizzyPopup.swift
//  Dizzy
//
//  Created by Menashe, Or on 26/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class DizzyPopup: UIView {
    
    private let imageView = PlaceImageView()
    private let messageLabel = UILabel()
    private let approveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let backgroundView = UIView()
    
    private let buttonsHeight: CGFloat = 34
    private let buttonsCornerRadius: CGFloat = 10
    private let imageViewSize: CGFloat = 101
    
    private let imageUrl: String?
    private let message: String
    
    var onOk: (() -> Void)?
    var onCancel: (() -> Void)?

    init(imageUrl: String?, message: String) {
        self.imageUrl = imageUrl
        self.message = message
        super.init(frame: CGRect.zero)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([backgroundView, messageLabel, approveButton, cancelButton, imageView])
    }
    
    private func layoutViews() {
        layoutImageView()
        layoutMessageLabel()
        layoutApproveButton()
        layoutCancelButton()
        layoutBackgroundView()
    }
    
    private func layoutImageView() {
        imageView.snp.makeConstraints { imageView in
            imageView.top.equalToSuperview()
            imageView.height.width.equalTo(imageViewSize)
            imageView.centerX.equalToSuperview()
        }
    }
    
    private func layoutMessageLabel() {
        messageLabel.snp.makeConstraints { messageLabel in
            messageLabel.top.equalTo(imageView.snp.bottom).offset(Metrics.doublePadding)
            messageLabel.leading.equalToSuperview().offset(Metrics.doublePadding)
            messageLabel.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func layoutApproveButton() {
        approveButton.snp.makeConstraints { approveButton in
            approveButton.top.equalTo(messageLabel.snp.bottom).offset(Metrics.oneAndHalfPadding)
            approveButton.trailing.equalToSuperview().offset(-Metrics.doublePadding)
            approveButton.leading.equalTo(cancelButton.snp.trailing).offset(Metrics.padding)
            approveButton.bottom.equalToSuperview().offset(-Metrics.oneAndHalfPadding)
            approveButton.height.equalTo(buttonsHeight)
        }
    }
    
    private func layoutCancelButton() {
        cancelButton.snp.makeConstraints { cancelButton in
            cancelButton.top.equalTo(approveButton.snp.top)
            cancelButton.bottom.equalTo(approveButton.snp.bottom)
            cancelButton.leading.equalToSuperview().offset(Metrics.doublePadding)
            cancelButton.width.equalTo(approveButton.snp.width)
        }
    }
    
    private func layoutBackgroundView() {
        backgroundView.snp.makeConstraints { backgroundView in
            backgroundView.leading.trailing.bottom.equalToSuperview()
            backgroundView.top.equalTo(imageView.snp.centerY)
        }
    }
    
    private func setupViews() {
        backgroundColor = .clear
        setupImageView()
        setupMessageLabel()
        setupApproveButton()
        setupCancelButton()
        setupBackgroundView()
    }
    
    private func setupImageView() {
        guard let imageUrlString = imageUrl,
            let imageUrl = URL(string: imageUrlString) else {
                return
        }
        
        imageView.imageSize = imageViewSize
        imageView.setImage(from: imageUrl)
    }
    
    private func setupMessageLabel() {
        messageLabel.font = Fonts.h8(weight: .bold)
        messageLabel.text = message
        messageLabel.textAlignment = .center
    }
    
    private func setupApproveButton() {
        approveButton.setTitle("YES".localized, for: .normal)
        approveButton.setTitleColor(.white, for: .normal)
        approveButton.titleLabel?.font = Fonts.h7(weight: .bold)
        approveButton.layer.cornerRadius = buttonsCornerRadius
        approveButton.backgroundColor = .primeryPurple
        approveButton.addTarget(self, action: #selector(onApprove), for: .touchDragInside)
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle("NO".localized, for: .normal)
        cancelButton.setTitleColor(.primeryPurple, for: .normal)
        cancelButton.titleLabel?.font = Fonts.h7(weight: .bold)
        cancelButton.layer.cornerRadius = buttonsCornerRadius
        cancelButton.backgroundColor = .white
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = buttonsCornerRadius
    }
    
    @objc private func onApprove() {
        onOk?()
    }
}
