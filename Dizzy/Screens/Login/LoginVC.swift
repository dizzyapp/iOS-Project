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
    let loginSelectionView: LoginSelectionView = LoginSelectionView()
    let appInfoView: AppInfoView = AppInfoView()
    
    let dizzyLogoImageView = UIImageView()
    
    let enterAsAdminButton: UIButton = UIButton()
    
    let cornerRadius: CGFloat = 25.0

    var loginVM: LoginVMType
    
    init(loginVM: LoginVMType) {
        self.loginVM = loginVM
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
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
                                        appInfoView, dizzyLogoImageView, enterAsAdminButton])
        
    }
    private func layoutViews() {
        
        layoutCloseButton()
        layoutLoginContainerView()
        
        layoutTitleLabel()
        layoutSubtitleLabel()
        layoutLoginSelectionView()
        layoutAppInfoView()
        
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
    
    private func layoutAppInfoView() {
        appInfoView.snp.makeConstraints { appInfoView in
            appInfoView.top.equalTo(loginSelectionView.snp.bottom).offset(Metrics.doublePadding)
            appInfoView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutDizzyLogo() {
        dizzyLogoImageView.snp.makeConstraints { dizzyLogoImageView in
            dizzyLogoImageView.top.equalTo(appInfoView.snp.bottom).offset(Metrics.doublePadding)
            dizzyLogoImageView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutEnterAsAdminButton() {
        enterAsAdminButton.snp.makeConstraints { enterAsAdminButton in
            enterAsAdminButton.top.equalTo(dizzyLogoImageView.snp.bottom).offset(Metrics.doublePadding)
            enterAsAdminButton.leading.trailing.equalToSuperview()
            enterAsAdminButton.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupViews() {
        setupCloseButton()
        setupLoginContainerView()
        
        setupTitleLabel()
        setupSubtitleLabel()
        setupLoginSelectionView()
        setupAppInfoView()
        
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
    
    private func setupAppInfoView() {
        appInfoView.delegate = self

    }
    
    private func setupDizzyLogo() {
        dizzyLogoImageView.image = Images.defaultPlaceAvatar()

    }
    
    private func setupEnterAsAdminButton() {
        let text: NSMutableAttributedString = NSMutableAttributedString(string: "enter as admin".localized)
        let range: NSRange = NSMakeRange(0, text.length)
        text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        enterAsAdminButton.setAttributedTitle(text, for: .normal)

    }
    
    @objc private func closeButtonClicked() {
        
    }
}

// MARK: - LoginSelectionView Delegates
extension LoginVC: LoginSelectionViewDelegate {
    func loginWithFBPressed() {
        
    }
    
    func loginWithDizzyPressed() {
        
    }
    
    func createNewAccountPressed() {
        
    }
}

// MARK:- AppInfoView Delegates
extension LoginVC: AppInfoViewDelegate {
    func aboutButtonPressed() {
        
    }
    
    func termsOfUsPressed() {
        
    }
    
    func privacyPolicyPressed() {
        
    }
    
    func contactUsPressed() {
        
    }
}
