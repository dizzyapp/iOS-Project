//
//  LoginSelectionView.swift
//  Dizzy
//
//  Created by stas berkman on 04/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol LoginSelectionViewDelegate: class {
    func loginWithDizzyButtonPressed()
    func loginWithFacebookButtonPressed()
    func signUpButtonPressed()
}

let signUpButtonColor = UIColor(hexString: "4C69EF")

class LoginSelectionView: UIView {

    weak var delegate: LoginSelectionViewDelegate?

    let loginWithDizzyButton = UIButton()
    let loginFacebookButton = UIButton()
    let orLabel = UILabel()
    let signUpButton = UIButton()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([loginWithDizzyButton, loginFacebookButton, orLabel, signUpButton])
    }
    
    private func layoutViews() {
        
        layoutLoginWithDizzyButton()
        layoutLoginFacebookButton()
        layoutOrLabel()
        layoutSignUpButton()
    }
    
    private func layoutLoginWithDizzyButton() {
        loginWithDizzyButton.snp.makeConstraints { loginWithDizzyButton in
            loginWithDizzyButton.top.equalToSuperview().offset(Metrics.doublePadding)
            loginWithDizzyButton.centerX.equalToSuperview()
            loginWithDizzyButton.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    private func layoutLoginFacebookButton() {
        loginFacebookButton.snp.makeConstraints { loginFacebookButton in
            loginFacebookButton.top.equalTo(loginWithDizzyButton.snp.bottom).offset(Metrics.doublePadding)
            loginFacebookButton.centerX.equalToSuperview()
            loginFacebookButton.width.equalTo(loginWithDizzyButton)
        }
    }
    
    private func layoutOrLabel() {
        orLabel.snp.makeConstraints { orLabel in
            orLabel.top.equalTo(loginFacebookButton.snp.bottom).offset(Metrics.padding)
            orLabel.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutSignUpButton() {
        signUpButton.snp.makeConstraints { signUpButton in
            signUpButton.top.equalTo(orLabel.snp.bottom).offset(Metrics.padding)
            signUpButton.centerX.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupLoginWithDizzyButton()
        setupLoginWithFacebookButton()
        setupOrLabel()
        setupSignUpButton()
    }
    
    private func setupLoginWithDizzyButton() {
        loginWithDizzyButton.setTitle("Log in with dizzy".localized, for: .normal)
        loginWithDizzyButton.titleLabel?.font = Fonts.h7()
        loginWithDizzyButton.setImage(Images.dizzyIcon(), for: .normal)
        loginWithDizzyButton.setBackgroundImage(Images.loginIcon(), for: .normal)
        loginWithDizzyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        loginWithDizzyButton.addTarget(self, action: #selector(loginWithDizzyButtonPressed), for: .touchUpInside)
    }
    
    private func setupLoginWithFacebookButton() {
        loginFacebookButton.setTitle("Log in with facebook".localized, for: .normal)
        loginFacebookButton.titleLabel?.font = Fonts.h7()
        loginFacebookButton.setImage(Images.facebookIcon(), for: .normal)
        loginFacebookButton.setBackgroundImage(Images.loginIcon(), for: .normal)
        loginFacebookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        loginFacebookButton.addTarget(self, action: #selector(loginWithFacebookButtonPressed), for: .touchUpInside)
        
    }
    
    private func setupOrLabel() {
        orLabel.textAlignment = .center
        orLabel.font = Fonts.h8()
        orLabel.text = "or".localized
    }
    private func setupSignUpButton() {
        
        signUpButton.setBackgroundImage(Images.signUpIcon(), for: .normal)
        signUpButton.setTitle("Sign up".localized, for: .normal)
        signUpButton.setTitleColor(signUpButtonColor, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)

    }
    
    @objc private func loginWithDizzyButtonPressed() {
        self.delegate?.loginWithDizzyButtonPressed()
    }
    
    @objc private func loginWithFacebookButtonPressed() {
        self.delegate?.loginWithFacebookButtonPressed()
    }
    
    @objc private func signUpButtonPressed() {
        self.delegate?.signUpButtonPressed()
    }
}
