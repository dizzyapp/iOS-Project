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

    let mainContainerView: UIView = UIView()
    let closeButton: UIButton = UIButton()
    let loginContainerView: UIView = UIView()
    
    let titleLabel: UILabel = UILabel()
    let subtitleLabel: UILabel = UILabel()
    let loginSelectionView: LoginSelectionView = LoginSelectionView()
    let appInfoView: AppInfoView = AppInfoView()
    
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
        mainContainerView.addSubviews([closeButton, loginContainerView])
        loginContainerView.addSubviews([titleLabel,
                                        subtitleLabel, loginSelectionView, appInfoView, enterAsAdminButton])
        mainContainerView.backgroundColor = .green
        self.view.addSubview(mainContainerView)
    }
    private func layoutViews() {
        
        layoutMainContainerView()
        layoutCloseButton()
        layoutLoginContainerView()
        
        layoutTitleLabel()
        layoutSubtitleLabel()
        layoutLoginSelectionView()
        layoutAppInfoView()
        
        layoutEnterAsAdminButton()
    }
    
    private func layoutMainContainerView() {
        mainContainerView.snp.makeConstraints { mainContainerView in
            mainContainerView.centerY.equalToSuperview()
            mainContainerView.leading.equalToSuperview()
            mainContainerView.trailing.equalToSuperview()
            mainContainerView.top.equalToSuperview().offset(20)
            mainContainerView.bottom.equalToSuperview()
        }
    }
    
    private func layoutCloseButton() {
        closeButton.snp.makeConstraints { closeButton in
            
            closeButton.top.equalTo(mainContainerView.snp.top)
            closeButton.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func layoutLoginContainerView() {
        loginContainerView.snp.makeConstraints { loginContainerView in
            
            loginContainerView.top.equalTo(closeButton.snp.bottom).offset(Metrics.doublePadding)
            loginContainerView.leading.trailing.equalToSuperview()
            loginContainerView.bottom.equalToSuperview().offset(Metrics.doublePadding)
        }
    }
    
    private func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.leading.trailing.equalToSuperview()
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
            loginSelectionView.top.equalTo(subtitleLabel.snp.bottom).offset(Metrics.doublePadding)
            loginSelectionView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutAppInfoView() {
        appInfoView.snp.makeConstraints { appInfoView in
            appInfoView.top.equalTo(loginSelectionView.snp.bottom).offset(Metrics.doublePadding)
            appInfoView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutEnterAsAdminButton() {
        
    }
    
    private func setupViews() {
        setupMainContainerView()
        setupCloseButton()
        setupLoginContainerView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupLoginSelectionView()
        setupAppInfoView()
    }
    
    private func setupMainContainerView() {
//        mainContainerView.backgroundColor = .clear
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
    @objc private func closeButtonClicked() {
        
    }
}

extension LoginVC: LoginSelectionViewDelegate {
    func loginWithFBPressed() {
        
    }
    
    func loginWithDizzyPressed() {
        
    }
    
    func createNewAccountPressed() {
        
    }
}

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
