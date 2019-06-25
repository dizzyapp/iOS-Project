//
//  LoginVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class LoginVC: UIViewController, LoadingContainer, AlertPresentation {
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    let loginContainerView = UIView()
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let loginSelectionView = LoginSelectionView()
    let appInfosView = AppInfosView()
    let userProfileView = UserProfileView()
    
    let dizzyLogoImageView = UIImageView()
    
    let enterAsAdminButton: UIButton = UIButton(type: .system)
    
    let cornerRadius: CGFloat = 30.0
    let enterAsAdminButtonHeight: CGFloat = 40
    
    var loginVM: LoginVMType
    
    init(loginVM: LoginVMType) {
        self.loginVM = loginVM
        
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        self.loginVM.delegate = self

        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {

        self.view.addSubview(loginContainerView)
        loginContainerView.addSubviews([titleLabel, subtitleLabel, loginSelectionView,
                                        userProfileView, appInfosView, dizzyLogoImageView, enterAsAdminButton])
        
    }
    private func layoutViews() {
        layoutLoginContainerView()
        
        layoutTitleLabel()
        layoutSubtitleLabel()
        layoutLoginSelectionView()
        layoutAppInfosView()
        layoutUserProfileView()
        
        layoutDizzyLogo()
        layoutEnterAsAdminButton()
    }
    
    private func layoutLoginContainerView() {
        loginContainerView.snp.makeConstraints { loginContainerView in
            
            loginContainerView.top.equalTo(view.snp.topMargin).offset(Metrics.padding)
            loginContainerView.leading.trailing.equalToSuperview()
            loginContainerView.bottom.equalToSuperview().offset(Metrics.doublePadding)
        }
    }
    
    private func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(Metrics.padding)
            titleLabel.centerX.equalToSuperview()
            titleLabel.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutSubtitleLabel() {
        subtitleLabel.snp.makeConstraints { subtitleLabel in
            subtitleLabel.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
            subtitleLabel.leading.trailing.equalToSuperview()
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
    
    private func layoutUserProfileView() {
        userProfileView.snp.makeConstraints { userProfileView in
            userProfileView.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
            userProfileView.leading.trailing.equalToSuperview()
            userProfileView.bottom.equalTo(loginSelectionView.snp.bottom)
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
        setupNavigationView()
        setupLoginContainerView()
        
        setupTitleLabel()
        setupSubtitleLabel()
        setupLoginSelectionView()
        setupAppInfosView()
        setupUserProfileView()
        
        setupDizzyLogo()
        setupEnterAsAdminButton()
    }
    
    private func setupNavigationView() {
        self.navigationItem.title = "Login".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.downArrowIcon(), style: .done, target: self, action: #selector(closeButtonClicked))
    }
    
    private func setupLoginContainerView() {
        loginContainerView.backgroundColor = .white
        loginContainerView.layer.cornerRadius = cornerRadius
        loginContainerView.clipsToBounds = true
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
    
    private func setupUserProfileView() {
        userProfileView.backgroundColor = .white
        userProfileView.isHidden = !self.loginVM.isUserLoggedIn()
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
        self.loginVM.loginWithFacebookButtonPressed(presentedVC: self)
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

// MARK: LoginVM Delegates
extension LoginVC: LoginVMDelegate {
    func userSignedInSuccesfully(user: DizzyUser) {
        hideSpinner()
    }
    
    func userSignedInFailed(error: SignInWebserviceError) {
        hideSpinner()
        showAlert(title: "Error".localized, message: error.localizedDescription)
    }
}