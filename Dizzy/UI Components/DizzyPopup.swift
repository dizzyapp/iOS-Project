//
//  DizzyPopup.swift
//  Dizzy
//
//  Created by Menashe, Or on 26/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class DizzyPopup: UIView {
    private let popupContainer = UIView()
    private let imageView = PlaceImageView()
    private let messageLabel = UILabel()
    private let approveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let backgroundView = UIView()
    
    private let buttonsHeight: CGFloat = 40
    private let buttonsCornerRadius: CGFloat = 15
    private let popUpCornerRadius: CGFloat = 25
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
        observeWhenAppGoesToBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observeWhenAppGoesToBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func willResignActive(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.removeFromSuperview()
        }
    }
    
    private func addSubviews() {
        self.addSubview(popupContainer)
        self.popupContainer.addSubviews([backgroundView, messageLabel, approveButton, cancelButton, imageView])
    }
    
    private func layoutViews() {
        layoutPopupContainer()
        layoutImageView()
        layoutMessageLabel()
        layoutApproveButton()
        layoutCancelButton()
        layoutBackgroundView()
    }
    
    private func layoutPopupContainer() {
        popupContainer.snp.makeConstraints { popupContainer in
            popupContainer.centerY .equalToSuperview()
            popupContainer.leading.equalToSuperview().offset(Metrics.doublePadding)
            popupContainer.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
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
        setupBlurEffect()
        setupImageView()
        setupMessageLabel()
        setupApproveButton()
        setupCancelButton()
        setupBackgroundView()
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blurEffectView.alpha = 0.7
        self.insertSubview(blurEffectView, at: 0)
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
        approveButton.backgroundColor = .blue
        approveButton.addTarget(self, action: #selector(onApprove), for: .touchUpInside)
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle("NO".localized, for: .normal)
        cancelButton.setTitleColor(.blue, for: .normal)
        cancelButton.titleLabel?.font = Fonts.h7(weight: .bold)
        cancelButton.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(onDecline), for: .touchUpInside)
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = popUpCornerRadius
    }
    
    private func hidePopup() {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
    
    @objc private func onApprove() {
        hidePopup()
        onOk?()
        self.removeFromSuperview()
    }
    
    @objc private func onDecline() {
        hidePopup()
        onCancel?()
        self.removeFromSuperview()
    }
}
