//
//  SignInDetailsView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignInDetailsViewDelegate: class {
    func onSignInPressed(_ loginCredentialsDetails: LoginCredentialsDetails)
}

final class SignInDetailsView: UIView {

    let titleLabel = UILabel()
    let stackView = UIStackView()
    let emailTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Email".localized)
    let passwordTextField = UITextField().withDarkPurpleRoundedCorners(withPlaceHolder: "Password".localized)
    let signInButton = UIButton(type: .system)
    let errorLabel = UILabel()
    
    let screenCornerRadius = CGFloat(30)
    let buttonsWidthPrecentage = CGFloat(0.5)
    let signInButtonBackgroundColor = UIColor(red:0.43, green:0.38, blue:0.98, alpha:1)
    let signInCornerRadius = CGFloat(17)
    
    weak var delegate: SignInDetailsViewDelegate?
    
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
        layoutEmailTextField()
        layoutPasswordTextField()
        layoutSignInButton()
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
    
    private func layoutSignInButton() {
        stackView.addArrangedSubview(signInButton)
        signInButton.snp.makeConstraints { (signInButton ) in
            signInButton.width.equalToSuperview().multipliedBy(buttonsWidthPrecentage)
        }
    }
    
    private func layoutErrorLabel() {
        errorLabel.snp.makeConstraints { (errorLabel ) in
            errorLabel.top.equalTo(stackView.snp.bottom).offset(Metrics.doublePadding)
            errorLabel.leading.equalToSuperview().offset(Metrics.doublePadding)
            errorLabel.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func setupViews() {
        layer.cornerRadius = screenCornerRadius
        self.clipsToBounds = true
        
        setupStackView()
        setupSignInButton()
        setupTitleLabel()
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
    
    private func setupSignInButton() {
        signInButton.setTitle("Go!".localized, for: .normal)
        signInButton.titleLabel?.font = Fonts.h10(weight: .bold)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.cornerRadius = signInCornerRadius
        signInButton.backgroundColor = signInButtonBackgroundColor
        signInButton.addTarget(self, action: #selector(onSignInPressed), for: .touchUpInside )
    }
    
    private func setupErrorLabel() {
        errorLabel.textColor = .red
        errorLabel.font = Fonts.h2(weight: .bold)
    }
    
    public func showErrorMessage(_ message: String) {
        self.errorLabel.text = message
    }
    
    @objc private func onSignInPressed() {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        let loginCredentialsDetails = LoginCredentialsDetails(fullName: "", email: email, password: password, repeatPassword: "")
        delegate?.onSignInPressed(loginCredentialsDetails)
    }
}
