//
//  LoginVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class LoginVC: UIViewController {

    let closeButton = UIButton()
    let loginContainerView = UIView()
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let loginSelectionView = LoginSelectionView()
    let appInfosView = AppInfosView()
    
    let dizzyLogoImageView = UIImageView()
    
    let enterAsAdminButton: UIButton = UIButton()
    
    let cornerRadius: CGFloat = 25.0
    let enterAsAdminButtonHeight: CGFloat = 40
    
    var loginVM: LoginVMType
    
    init(loginVM: LoginVMType) {
        self.loginVM = loginVM
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        
        addSubviews()
        layoutViews()
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {

        self.view.addSubviews([closeButton, loginContainerView])
        loginContainerView.addSubviews([titleLabel, subtitleLabel, loginSelectionView,
                                        appInfosView, dizzyLogoImageView, enterAsAdminButton])
        
    }
    private func layoutViews() {
        
        layoutCloseButton()
        layoutLoginContainerView()
        
        layoutTitleLabel()
        layoutSubtitleLabel()
        layoutLoginSelectionView()
        layoutAppInfosView()
        
        layoutDizzyLogo()
        layoutEnterAsAdminButton()
    }
    
    private func layoutCloseButton() {
        closeButton.snp.makeConstraints { closeButton in
            
            closeButton.top.equalTo(self.view.snp.topMargin).offset(Metrics.padding)
            closeButton.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func layoutLoginContainerView() {
        loginContainerView.snp.makeConstraints { loginContainerView in
            
            loginContainerView.top.equalTo(closeButton.snp.bottom).offset(Metrics.padding)
            loginContainerView.leading.trailing.equalToSuperview()
            loginContainerView.bottom.equalToSuperview().offset(Metrics.doublePadding)
        }
    }
    
    private func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(Metrics.padding)
            titleLabel.leading.trailing.equalToSuperview().offset(Metrics.padding)
        }
    }
    
    private func layoutSubtitleLabel() {
        subtitleLabel.snp.makeConstraints { subtitleLabel in
            subtitleLabel.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
            subtitleLabel.leading.trailing.equalToSuperview().offset(Metrics.padding)
        }
    }
    
    private func layoutLoginSelectionView() {
        loginSelectionView.snp.makeConstraints { loginSelectionView in
            loginSelectionView.top.equalTo(subtitleLabel.snp.bottom)
            loginSelectionView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutAppInfosView() {
        appInfosView.snp.makeConstraints { appInfosView in
            appInfosView.top.equalTo(loginSelectionView.snp.bottom)
            appInfosView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutDizzyLogo() {
        dizzyLogoImageView.snp.makeConstraints { dizzyLogoImageView in
            dizzyLogoImageView.top.equalTo(appInfosView.snp.bottom).offset(2 * Metrics.doublePadding)
            dizzyLogoImageView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutEnterAsAdminButton() {
        enterAsAdminButton.snp.makeConstraints { enterAsAdminButton in
            enterAsAdminButton.top.equalTo(dizzyLogoImageView.snp.bottom).offset(Metrics.doublePadding)
            enterAsAdminButton.leading.trailing.equalToSuperview()
            enterAsAdminButton.height.equalTo(enterAsAdminButtonHeight)
            enterAsAdminButton.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupViews() {
        setupCloseButton()
        setupLoginContainerView()
        
        setupTitleLabel()
        setupSubtitleLabel()
        setupLoginSelectionView()
        setupAppInfosView()
        
        setupDizzyLogo()
        setupEnterAsAdminButton()
    }
    
    private func setupCloseButton() {
        closeButton.setImage(Images.downArrowIcon(), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
    }
    
    private func setupLoginContainerView() {
        loginContainerView.backgroundColor = .white
        loginContainerView.layer.cornerRadius = cornerRadius
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h5()
        titleLabel.text = "Menu".localized
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = Fonts.h5(weight: .bold)
        subtitleLabel.text = "Welcome to Dizzy!".localized
    }
    
    private func setupLoginSelectionView() {
        loginSelectionView.delegate = self

    }
    
    private func setupAppInfosView() {
        appInfosView.delegate = self
    }
    
    private func setupDizzyLogo() {
        dizzyLogoImageView.image = Images.dizzyLogo()
        dizzyLogoImageView.contentMode = .center
    }
    
    private func setupEnterAsAdminButton() {
        let text: NSMutableAttributedString = NSMutableAttributedString(string: "enter as admin".localized)
        let range: NSRange = NSMakeRange(0, text.length)
        
        text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        text.addAttribute(.font, value: Fonts.h8(), range: range)

        enterAsAdminButton.setAttributedTitle(text, for: .normal)
        enterAsAdminButton.addTarget(self, action: #selector(enterAsAdminButtonPressed), for: .touchUpInside)
    }
    
    @objc private func closeButtonClicked() {
        self.loginVM.closeButtonPressed()
    }
    
    @objc private func enterAsAdminButtonPressed() {
        self.loginVM.enterAsAdminButtonPressed()
    }
}

// MARK: LoginSelectionView Delegates
extension LoginVC: LoginSelectionViewDelegate {
    func loginWithFacebookButtonPressed() {
        self.loginVM.loginWithFacebookButtonPressed()
    }
    
    func loginWithDizzyButtonPressed() {
        self.loginVM.loginWithDizzyButtonPressed()
    }
    
    func signUpButtonPressed() {
        self.loginVM.signUpButtonPressed()
    }
}

// MARK: AppInfoView Delegates
extension LoginVC: AppInfosViewDelegate {
    func appInfoButtonPressed(appInfosView: AppInfosView, type: AppInfoType) {
        self.loginVM.appInfoButtonPressed(type: type)
    }
}
