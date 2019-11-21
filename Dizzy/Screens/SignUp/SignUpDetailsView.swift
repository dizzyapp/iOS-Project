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
    let fullNameTextField = UITextField().loginTextfield(withPlaceholder: "Name".localized)
    let emailTextField = UITextField().loginTextfield(withPlaceholder: "Email".localized)
    let passwordTextField = UITextField().loginTextfield(withPlaceholder: "Password".localized)
    let confirmPasswordTextField = UITextField().loginTextfield(withPlaceholder: "Confirm Password".localized)
    let signUpButton = UIButton(type: .system)
    
    let screenCornerRadius = CGFloat(30)
    let buttonsWidthPrecentage = CGFloat(0.75)
    let signUpbuttonWidthPercentage = CGFloat(0.45)
    let signupButtonBackgroundColor = UIColor.dizzyBlue
    let signupCornerRadius = CGFloat(14)
    let stackViewTopPadding = Metrics.doublePadding * 2
    
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
        self.addSubviews([self.stackView])
        self.stackView.snp.makeConstraints { stackView in
            stackView.top.equalTo(titleLabel.snp.bottom).offset(stackViewTopPadding)
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
            signUpButton.width.equalToSuperview().multipliedBy(signUpbuttonWidthPercentage)
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
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h8(weight: .bold)
        titleLabel.textColor = .blue
        titleLabel.text = "SIGN UP".localized
    }
    
    private func setupStackView() {
        stackView.spacing = Metrics.doublePadding
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .white
    }
    
    private func setupFullNameTextField() {
        fullNameTextField.keyboardType = .namePhonePad
    }
    
    private func setupEmailTextField() {
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
    }
    
    private func setupPasswordTextField() {
        self.passwordTextField.isSecureTextEntry = true
    }
    
    private func setupRepeatPasswordTextField() {
        self.confirmPasswordTextField.isSecureTextEntry = true
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle("DONE".localized, for: .normal)
        signUpButton.titleLabel?.font = Fonts.h8(weight: .bold)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = signupCornerRadius
        signUpButton.backgroundColor = signupButtonBackgroundColor
        signUpButton.addTarget(self, action: #selector(onSignupPressed), for: .touchUpInside )
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
