//
//  SignInDetailsView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SignInDetailsViewDelegate: class {
    func onSignInPressed(_ signInDetails: SignInDetails)
}

final class SignInDetailsView: UIView {

    let titleLabel = UILabel()
    let stackView = UIStackView()
    let emailTextField = UITextField().loginTextfield(withPlaceholder: "Email".localized)
    let passwordTextField = UITextField().loginTextfield(withPlaceholder: "Password".localized)
    let signInButton = UIButton(type: .system)
    
    let screenCornerRadius = CGFloat(0)
    let buttonsWidthPrecentage = CGFloat(0.75)
    let signInButtonBackgroundColor = UIColor.dizzyBlue
    let signInButtonWidthPrecentage = CGFloat(0.45)
    let signInCornerRadius = CGFloat(14)
    let stackViewTopPadding = Metrics.doublePadding * 2
    
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
            signInButton.width.equalToSuperview().multipliedBy(signInButtonWidthPrecentage)
        }
    }
    
    private func setupViews() {
        
        setupView()
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupStackView()
        setupSignInButton()
    }
    
    private func setupView() {
        self.layer.cornerRadius = screenCornerRadius
        self.clipsToBounds = true
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h9(weight: .bold)
        titleLabel.textColor = .blue
        titleLabel.text = "LOG IN".localized
    }
    
    private func setupEmailTextField() {
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
    }
    
    private func setupPasswordTextField() {
        self.passwordTextField.isSecureTextEntry = true
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.spellCheckingType = .no
    }
    
    private func setupStackView() {
        stackView.spacing = Metrics.doublePadding
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.backgroundColor = .white
    }
    
    private func setupSignInButton() {
        signInButton.setTitle("ENTER".localized, for: .normal)
        signInButton.titleLabel?.font = Fonts.h8(weight: .bold)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.cornerRadius = signInCornerRadius
        signInButton.backgroundColor = signInButtonBackgroundColor
        signInButton.addTarget(self, action: #selector(onSignInPressed), for: .touchUpInside )
    }

    @objc private func onSignInPressed() {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        let signInDetails = SignInDetails(email: email, password: password)
        delegate?.onSignInPressed(signInDetails)
    }
}
