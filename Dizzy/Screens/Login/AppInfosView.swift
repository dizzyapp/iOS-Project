//
//  AppInfoView.swift
//  Dizzy
//
//  Created by stas berkman on 05/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol AppInfosViewDelegate: class {
    func appInfoButtonPressed(appInfosView: AppInfosView, type: AppInfoType)
}

enum AppInfoType: String {
    case about = "About"
    case termsOfUse = "Terms of Use"
    case privacyPolicy = "Privacy Policy"
    case contactUs = "Contact Us"
}

class AppInfoView: UIView {
    let stackView = UIStackView()
    let infoButton = UIButton()
    let separatorView = UIView()
    
    let separatorMultipliedWidth: CGFloat = 0.6
    let separatorHeight: CGFloat = 0.5
    let separatorBackgroundColor: UIColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)
    
    var appInfoType: AppInfoType? {
        didSet {
            self.setupViews()
        }
    }
    var shouldIncludeSeparator: Bool = true {
        didSet {
            self.setupViews()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(infoButton)
        stackView.addArrangedSubview(separatorView)
        
        self.addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutStackView()
        layoutSeparatorView()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.edges.equalToSuperview()
        }
    }
    private func layoutSeparatorView() {
        separatorView.snp.makeConstraints { separatorView in
            separatorView.height.equalTo(separatorHeight)
            separatorView.width.equalTo(self).multipliedBy(separatorMultipliedWidth)
        }
    }
    
    private func setupViews() {
        setupStackView()
        setupInfoButton()
        setupSeparatorView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
    }
    
    private func setupInfoButton() {
        infoButton.setTitle(appInfoType?.rawValue, for: .normal)
        infoButton.setTitleColor(.lightGray, for: .normal)
        infoButton.titleLabel?.font = Fonts.h5(weight: .bold)
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = separatorBackgroundColor
        separatorView.isHidden = !shouldIncludeSeparator
    }
}

class AppInfosView: UIView {

    weak var delegate: AppInfosViewDelegate?

    let stackView = UIStackView()
    
    let aboutView = AppInfoView()
    let termsOfUseView = AppInfoView()
    let privacyPolicyView = AppInfoView()
    let contactUsView = AppInfoView()
    
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
        
        stackView.addArrangedSubview(aboutView)
        stackView.addArrangedSubview(termsOfUseView)
        stackView.addArrangedSubview(privacyPolicyView)
        stackView.addArrangedSubview(contactUsView)
        
        self.addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutStackView()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.edges.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupStackView()
        setupAboutView()
        setupTermsOfUseView()
        setupPrivacyPolicyView()
        setupContactUsView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
    }
    
    private func setupAboutView() {
        aboutView.appInfoType = .about
        aboutView.infoButton.addTarget(self, action: #selector(aboutButtonPressed), for: .touchUpInside)
    }
    
    private func setupTermsOfUseView() {
        termsOfUseView.appInfoType = .termsOfUse
        termsOfUseView.infoButton.addTarget(self, action: #selector(termsOfUseButtonPressed), for: .touchUpInside)
    }
    
    private func setupPrivacyPolicyView() {
        privacyPolicyView.appInfoType = .privacyPolicy
        privacyPolicyView.infoButton.addTarget(self, action: #selector(privacyPolicyButtonPressed), for: .touchUpInside)

    }

    private func setupContactUsView() {
        contactUsView.appInfoType = .contactUs
        contactUsView.infoButton.addTarget(self, action: #selector(contactUsButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func aboutButtonPressed() {
        self.delegate?.appInfoButtonPressed(appInfosView: self, type: .about)
    }
    
    @objc
    private func termsOfUseButtonPressed() {
        self.delegate?.appInfoButtonPressed(appInfosView: self, type: .termsOfUse)
    }
    
    @objc
    private func privacyPolicyButtonPressed() {
        self.delegate?.appInfoButtonPressed(appInfosView: self, type: .privacyPolicy)
    }
    
    @objc
    private func contactUsButtonPressed() {
        self.delegate?.appInfoButtonPressed(appInfosView: self, type: .contactUs)
    }
}
