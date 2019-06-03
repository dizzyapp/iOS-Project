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

    let titleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let signUpButton = UIButton()
    
    var loginVM: LoginVMType
    
    init(loginVM: LoginVMType) {
        self.loginVM = loginVM
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        let container = UIView()
        container.addSubviews([titleLabel, emailTextField, passwordTextField, loginButton, signUpButton])
        view.addSubview(container)
        container.snp.makeConstraints { container in
            container.centerY.equalToSuperview()
            container.leading.equalToSuperview().offset(Metrics.doublePadding)
            container.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
        
        layoutTitleLabel()
        layoutEmailTextField()
        layoutPasswordTextField()
        layoutLoginButton()
        layoutSignInButton()
    }
    
    private func layoutTitleLabel() {
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutEmailTextField() {
        emailTextField.snp.makeConstraints { emailTextField in
            emailTextField.top.equalTo(titleLabel.snp.bottom).offset(Metrics.padding)
            emailTextField.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutPasswordTextField() {
        passwordTextField.snp.makeConstraints { passwordTextField in
            passwordTextField.top.equalTo(emailTextField.snp.bottomMargin).offset(Metrics.padding)
            passwordTextField.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutLoginButton() {
        loginButton.snp.makeConstraints { loginButton in
            loginButton.centerX.equalToSuperview()
            loginButton.top.equalTo(passwordTextField.snp.bottom).offset(Metrics.padding)
        }
    }
    
    private func layoutSignInButton() {
        signUpButton.snp.makeConstraints { signupButton in
            signupButton.top.equalTo(loginButton).offset(Metrics.padding)
        }
    }
    
    private func setupViews() {
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignupButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h5()
        titleLabel.text = "Please login or sign in".localized
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = "Email".localized
    }
    
    private func setupPasswordTextField() {
        passwordTextField.placeholder = "Password".localized
    }
    
    private func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.addTarget(self, action: #selector(onLoginPressed), for: .touchUpInside)
    }
    
    private func setupSignupButton() {
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(onSignInPressed), for: .touchUpInside)
    }
    
    @objc private func onLoginPressed() {
        
    }
    
    @objc private func onSignInPressed() {
        
    }

}
