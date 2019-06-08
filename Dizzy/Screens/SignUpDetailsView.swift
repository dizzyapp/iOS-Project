//
//  SignUpDetailsView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class SignUpDetailsView: UIView {

    let stackView = UIStackView()
    let fullNameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let signUpButton = UIButton()
    
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
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { stackView in
            stackView.top.leading.trailing.equalToSuperview()
        }
        
        stackView.addArrangedSubview(fullNameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(signUpButton)
    }
    
    private func setupViews() {
        setupStackView()
        setupTextFields()
    }
    
    private func setupStackView() {
        stackView.spacing = Metrics.padding
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupTextFields() {
        fullNameTextField.placeholder = "Whats your name?"
        emailTextField.placeholder = "Whats your email?"
        passwordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm your password"
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle("Done", for: .normal)
    }

}
