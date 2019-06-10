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

class AppInfosView: UIView {

    weak var delegate: AppInfosViewDelegate?

    let stackView = UIStackView()
    
    let aboutView = AppInfoView(.about)
    let termsOfUseView = AppInfoView(.termsOfUse)
    let privacyPolicyView = AppInfoView(.privacyPolicy)
    let contactUsView = AppInfoView(.contactUs)
    
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
        aboutView.infoButton.addTarget(self, action: #selector(aboutButtonPressed), for: .touchUpInside)
    }
    
    private func setupTermsOfUseView() {
        termsOfUseView.infoButton.addTarget(self, action: #selector(termsOfUseButtonPressed), for: .touchUpInside)
    }
    
    private func setupPrivacyPolicyView() {
        privacyPolicyView.infoButton.addTarget(self, action: #selector(privacyPolicyButtonPressed), for: .touchUpInside)
    }

    private func setupContactUsView() {
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
