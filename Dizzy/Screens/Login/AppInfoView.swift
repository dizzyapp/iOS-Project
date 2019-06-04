//
//  AppInfoView.swift
//  Dizzy
//
//  Created by stas berkman on 05/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol AppInfoViewDelegate: class {
    func aboutButtonPressed()
    func termsOfUsPressed()
    func privacyPolicyPressed()
    func contactUsPressed()
}

class AppInfoView: UIView {

    weak var delegate: AppInfoViewDelegate?

    let stackView: UIStackView = UIStackView()
    
    let aboutButton: UIButton = UIButton()
    let aboutSeparatorView: UIView = UIView()
    
    let termsOfUseButton: UIButton = UIButton()
    let termsOfUseSeparatorView: UIView = UIView()

    let privacyPolicyButton: UIButton = UIButton()
    let privacyPolicySeparatorView: UIView = UIView()

    let contactUsButton: UIButton = UIButton()
    
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
        
        stackView.addArrangedSubview(aboutButton)
        stackView.addArrangedSubview(aboutSeparatorView)
        stackView.addArrangedSubview(termsOfUseButton)
        stackView.addArrangedSubview(termsOfUseSeparatorView)
        stackView.addArrangedSubview(privacyPolicyButton)
        stackView.addArrangedSubview(privacyPolicySeparatorView)
        stackView.addArrangedSubview(contactUsButton)
        
        self.addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutStackView()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupStackView()
        setupAboutButton()
        setupAboutSeparatorView()
        setupTermsOfUseButton()
        setupTermsOfUseSeparatorView()
        setupPrivacyPolicyButton()
        setupPrivacyPolicySeparatorView()
        setupContactUsButton()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
    }
    
    private func setupAboutButton() {
        
        aboutButton.titleLabel?.font = Fonts.h3()
        aboutButton.setTitle("About".localized, for: .normal)
    }
    private func setupAboutSeparatorView() {
        
    }
    private func setupTermsOfUseButton() {
        termsOfUseButton.titleLabel?.font = Fonts.h3()
        termsOfUseButton.setTitle("Terms of Use".localized, for: .normal)
    }
    private func setupTermsOfUseSeparatorView() {
        
    }
    private func setupPrivacyPolicyButton() {
        privacyPolicyButton.titleLabel?.font = Fonts.h3()
        privacyPolicyButton.setTitle("Privacy Policy".localized, for: .normal)
    }
    private func setupPrivacyPolicySeparatorView() {
        
    }
    private func setupContactUsButton() {
        contactUsButton.titleLabel?.font = Fonts.h3()
        contactUsButton.setTitle("Contact us".localized, for: .normal)
    }
}
