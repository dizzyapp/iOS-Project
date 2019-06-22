//
//  SignUpDetailsView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignUpDetailsViewDelegate: class {
    func onSignupPressed(_ signUpDetails: SignUpDetails)
}

final class SignUpDetailsView: UIView {

    let titleLabel = UILabel()
    let stackView = UIStackView()
    let fullNameTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "What's your name?".localized)
    let emailTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Whats your email?".localized)
    let passwordTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Password".localized)
    let confirmPasswordTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Confirm your password".localized)
    let signUpButton = UIButton(type: .system)
    let errorLabel = UILabel()
    
    let screenCornerRadius = CGFloat(30)
    let buttonsWidthPrecentage = CGFloat(0.5)
    let signupButtonBackgroundColor = UIColor(red:0.43, green:0.38, blue:0.98, alpha:1)
    let signupCornerRadius = CGFloat(17)
    
    weak var delegate: SignUpDetailsViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white

        layoutViews()
        setupViews()
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
        layoutErrorLabel()
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
        self.addSubviews([self.stackView, errorLabel])
        self.stackView.snp.makeConstraints { stackView in
            stackView.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
            stackView.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutFullNameTextField() {
        stackView.addArrangedSubview(fullNameTextField)
        fullNameTextField.snp.makeConstraints { (fullNameTextField ) in
            fullNameTextField.width.equalToSuperview().multipliedBy(buttonsWidthPrecentage)
        }
    }
    
    private func layoutEmailTextField() {
        stackView.addArrangedSubview(emailTextField)
        emailTextField.snp.makeConstraints { (emailTextField ) in
            emailTextField.width.equalToSuperview().multipliedBy(buttonsWidthPrecentage)
        }
    }
    
    private func layoutPasswordTextField() {
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (passwordTextField ) in
            passwordTextField.width.equalToSuperview().multipliedBy(buttonsWidthPrecentage)
        }
    }
    
    private func layoutConfirmPasswordTextField() {
        stackView.addArrangedSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { (confirmPasswordTextField ) in
            confirmPasswordTextField.width.equalToSuperview().multipliedBy(buttonsWidthPrecentage)
        }
    }
    
    private func layoutSignupButton() {
        stackView.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { (signUpButton ) in
            signUpButton.width.equalToSuperview().multipliedBy(buttonsWidthPrecentage)
        }
    }
    
    private func layoutErrorLabel() {
        errorLabel.snp.makeConstraints { (errorLabel ) in
            errorLabel.top.equalTo(stackView.snp.bottom).offset(Metrics.doublePadding)
            errorLabel.leading.equalToSuperview().offset(Metrics.doublePadding)
            errorLabel.trailing.equalToSuperview().offset(-Metrics.doublePadding)
            errorLabel.bottom.greaterThanOrEqualToSuperview().offset(Metrics.doublePadding)
        }
    }
    
    private func setupViews() {
        layer.cornerRadius = screenCornerRadius
        self.clipsToBounds = true
        
        setupTitleLabel()
        setupStackView()
        setupFullNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupRepeatPasswordTextField()
        setupSignUpButton()
        setupErrorLabel()
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
    
    private func setupFullNameTextField() {
        fullNameTextField.keyboardType = .namePhonePad
    }
    
    private func setupEmailTextField() {
        emailTextField.keyboardType = .emailAddress
    }
    
    private func setupPasswordTextField() {
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setupRepeatPasswordTextField() {
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle("Done!".localized, for: .normal)
        signUpButton.titleLabel?.font = Fonts.h10(weight: .bold)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = signupCornerRadius
        signUpButton.backgroundColor = signupButtonBackgroundColor
        signUpButton.addTarget(self, action: #selector(onSignupPressed), for: .touchUpInside )
    }
    
    private func setupErrorLabel() {
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red
        errorLabel.font = Fonts.h2(weight: .bold)
    }
    
    public func showErrorMessage(_ message: String) {
        self.errorLabel.text = message
    }
    
    @objc private func onSignupPressed() {
        
        guard let fullName = self.fullNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let repeatPassword = self.confirmPasswordTextField.text else {
                return
        }
        
        let signUpDetails = SignUpDetails(fullName: fullName, email: email, password: password, repeatPassword: repeatPassword)
        delegate?.onSignupPressed(signUpDetails)
    }
}
