//
//  LoginVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 28/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class LoginVC: UIViewController, LoadingContainer, PopupPresenter, CardVC {
    
    var cardContainerView: UIView = UIView()
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let loginSelectionView = LoginSelectionView()
    let appInfosView = AppInfosView()
    let userProfileView: UserProfileView
    
    let logoutButton: UIButton = UIButton(type: .system)
    
    let dizzyLogoImageView = UIImageView()
    
    let enterAsAdminButton: UIButton = UIButton(type: .system)
    
    let enterAsAdminButtonHeight: CGFloat = 40
    
    var loginVM: LoginVMType
    
    init(loginVM: LoginVMType) {
        self.loginVM = loginVM
        self.userProfileView = UserProfileView(user: loginVM.user)
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
        makeCard()
        cardContainerView.addSubviews([titleLabel, subtitleLabel, loginSelectionView,
                                        userProfileView, logoutButton, appInfosView, dizzyLogoImageView, enterAsAdminButton])
        
    }
    private func layoutViews() {
        layoutTitleLabel()
        layoutSubtitleLabel()
        layoutLoginSelectionView()
        layoutAppInfosView()
        layoutUserProfileView()
        layoutLogoutButton()
        
        layoutDizzyLogo()
        layoutEnterAsAdminButton()
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
    
    private func layoutUserProfileView() {
        userProfileView.snp.makeConstraints { userProfileView in
            userProfileView.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
            userProfileView.leading.trailing.equalToSuperview()
            userProfileView.bottom.equalTo(logoutButton.snp.top)
        }
    }
    
    private func layoutLogoutButton() {
        logoutButton.snp.makeConstraints { logoutButton in
            logoutButton.leading.trailing.equalToSuperview()
            logoutButton.bottom.equalTo(appInfosView.snp.top).offset(-Metrics.doublePadding)
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
        setupNavigationView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupLoginSelectionView()
        setupAppInfosView()
        setupUserProfileView()
        setupLogoutButton()
        
        setupDizzyLogo()
        setupEnterAsAdminButton()
    }
    
    private func setupNavigationView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.downArrowIcon(), style: .done, target: self, action: #selector(closeButtonClicked))
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h7(weight: .bold)
        titleLabel.textColor = .blue
        titleLabel.text = "CONNECT".localized
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = Fonts.h5(weight: .bold)
        subtitleLabel.text = "Welcome to Dizzy!".localized
    }
    
    private func setupLoginSelectionView() {
        loginSelectionView.delegate = self
        loginSelectionView.isHidden = self.loginVM.isUserLoggedIn()
    }
    
    private func setupAppInfosView() {
        appInfosView.delegate = self
    }
    
    private func setupUserProfileView() {
        userProfileView.backgroundColor = .white
        userProfileView.isHidden = !self.loginVM.isUserLoggedIn()
        userProfileView.delegate = self
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("Logout".localized, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        logoutButton.isHidden = !self.loginVM.isUserLoggedIn()
    }
    
    private func setupDizzyLogo() {
        dizzyLogoImageView.image = Images.dizzyLogo()
        dizzyLogoImageView.contentMode = .center
    }
    
    private func setupEnterAsAdminButton() {
        let text: NSMutableAttributedString = NSMutableAttributedString(string: "enter as admin".localized)
        let range: NSRange = NSRange(location: 0, length: text.length)
        
        text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        text.addAttribute(.font, value: Fonts.h8(), range: range)
        
        enterAsAdminButton.setAttributedTitle(text, for: .normal)
        enterAsAdminButton.addTarget(self, action: #selector(enterAsAdminButtonPressed), for: .touchUpInside)
    }
    
    private func setupSignInView() {
        self.loginSelectionView.isHidden = false
        self.userProfileView.isHidden = true
        self.logoutButton.isHidden = true
    }
    
    private func setupSignOutView() {
        self.loginSelectionView.isHidden = true
        self.userProfileView.isHidden = false
        self.logoutButton.isHidden = false
    }
    
    @objc private func closeButtonClicked() {
        self.loginVM.closeButtonPressed()
    }
    
    @objc private func enterAsAdminButtonPressed() {
        self.loginVM.enterAsAdminButtonPressed()
    }
    
    @objc private func logoutButtonPressed() {
        self.loginVM.logoutButtonPressed()
    }
}

// MARK: LoginSelectionView Delegates
extension LoginVC: LoginSelectionViewDelegate {
    func loginWithFacebookButtonPressed() {
        showSpinner()
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
    func userSignedInSuccesfully() {
        hideSpinner()
        setupSignOutView()
    }
    
    func userSignedInFailed(error: SignInWebserviceError) {
        hideSpinner()
        let action = Action(title: "Ok".localized)
        showPopup(with: "Error".localized, message: error.localizedDescription, actions: [action])
    }
    
    func userLoggedoutSuccessfully() {
        hideSpinner()
        setupSignInView()
    }
    
    func userLoggedoutFailed(error: Error) {
        hideSpinner()
        let action = Action(title: "Ok".localized)
        showPopup(with: "Error".localized, message: error.localizedDescription, actions: [action])
    }
}

extension LoginVC: UserProfileViewDelegate {
    func profileImagePressed() {
        loginVM.userProfileImagePressed()
    }
}
