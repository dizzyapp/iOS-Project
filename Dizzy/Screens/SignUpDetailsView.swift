//
//  SignUpDetailsView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class SignUpDetailsView: UIView {

    let titleLabel = UILabel()
    let stackView = UIStackView()
    let fullNameTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "What's your name?".localized)
    let emailTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Whats your email?".localized)
    let passwordTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Password".localized)
    let confirmPasswordTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Confirm your password".localized)
    let signUpButton = UIButton(type: .system)
    
    let cornerRadius = CGFloat(30)
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        setupViews()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        
        layoutTitleLabel()
        layoutStackView()
        layoutFullNameTextField()
        layoutEmailTextField()
        layoutPasswordTextField()
        layoutConfirmPasswordTextField()
        layoutSignupButton()
    }
    
    private func layoutTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(Metrics.doublePadding)
            titleLabel.leading.equalToSuperview().offset(Metrics.doublePadding)
            titleLabel.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func layoutStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { stackView in
            stackView.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
            stackView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutFullNameTextField() {
        stackView.addArrangedSubview(fullNameTextField)
        fullNameTextField.snp.makeConstraints { (fullNameTextField ) in
            fullNameTextField.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func layoutEmailTextField() {
        stackView.addArrangedSubview(emailTextField)
        emailTextField.snp.makeConstraints { (emailTextField ) in
            emailTextField.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func layoutPasswordTextField() {
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (passwordTextField ) in
            passwordTextField.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func layoutConfirmPasswordTextField() {
        stackView.addArrangedSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { (confirmPasswordTextField ) in
            confirmPasswordTextField.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func layoutSignupButton() {
        stackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { (signUpButton ) in
            signUpButton.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setupViews() {
        layer.cornerRadius = cornerRadius
        setupStackView()
        setupSignUpButton()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h10(weight: .medium)
        titleLabel.text = "Create new account".localized
    }
    
    private func setupStackView() {
        stackView.spacing = Metrics.padding
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .white
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle("Done!".localized, for: .normal)
        signUpButton.titleLabel?.font = Fonts.h10(weight: .bold)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 17
        signUpButton.backgroundColor = UIColor(red:0.43, green:0.38, blue:0.98, alpha:1)
    }

}
