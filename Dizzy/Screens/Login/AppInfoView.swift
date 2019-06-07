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
    func termsOfUsButtonPressed()
    func privacyPolicyButtonPressed()
    func contactUsButtonPressed()
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
        layoutAboutSeparatorView()
        layoutTermsOfUseSeparatorView()
        layoutPrivacyPolicySeparatorView()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func layoutAboutSeparatorView() {
        aboutSeparatorView.snp.makeConstraints { aboutSeparatorView in
            aboutSeparatorView.height.equalTo(0.5)
            aboutSeparatorView.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    private func layoutTermsOfUseSeparatorView() {
        termsOfUseSeparatorView.snp.makeConstraints { termsOfUseSeparatorView in
            termsOfUseSeparatorView.height.equalTo(0.5)
            termsOfUseSeparatorView.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    private func layoutPrivacyPolicySeparatorView() {
        privacyPolicySeparatorView.snp.makeConstraints { privacyPolicySeparatorView in
            privacyPolicySeparatorView.height.equalTo(0.5)
            privacyPolicySeparatorView.width.equalToSuperview().multipliedBy(0.6)
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
        stackView.alignment = .center
    }
    
    private func setupAboutButton() {
        
        aboutButton.setTitleColor(.lightGray, for: .normal)
        aboutButton.titleLabel?.font = Fonts.h3()
        aboutButton.setTitle("About".localized, for: .normal)
    }
    private func setupAboutSeparatorView() {
        aboutSeparatorView.backgroundColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)
    }
    private func setupTermsOfUseButton() {
        termsOfUseButton.setTitleColor(.lightGray, for: .normal)
        termsOfUseButton.titleLabel?.font = Fonts.h5()
        termsOfUseButton.setTitle("Terms of Use".localized, for: .normal)
    }
    private func setupTermsOfUseSeparatorView() {
        termsOfUseSeparatorView.backgroundColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)

    }
    private func setupPrivacyPolicyButton() {
        privacyPolicyButton.setTitleColor(.lightGray, for: .normal)
        privacyPolicyButton.titleLabel?.font = Fonts.h5()
        privacyPolicyButton.setTitle("Privacy Policy".localized, for: .normal)
    }
    private func setupPrivacyPolicySeparatorView() {
        privacyPolicySeparatorView.backgroundColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)

    }
    private func setupContactUsButton() {
        contactUsButton.setTitleColor(.lightGray, for: .normal)
        contactUsButton.titleLabel?.font = Fonts.h5()
        contactUsButton.setTitle("Contact us".localized, for: .normal)
    }
}
