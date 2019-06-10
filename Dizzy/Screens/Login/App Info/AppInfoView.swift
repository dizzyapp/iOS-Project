//
//  AppInfoView.swift
//  Dizzy
//
//  Created by stas berkman on 10/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

enum AppInfoType: String {
    case about = "About"
    case termsOfUse = "Terms of Use"
    case privacyPolicy = "Privacy Policy"
    case contactUs = "Contact Us"
}

class AppInfoView: UIView {

    let infoButton = UIButton()
    let separatorView = UIView()
    
    let separatorMultipliedWidth: CGFloat = 0.6
    let separatorHeight: CGFloat = 0.5
    let separatorBackgroundColor: UIColor = UIColor(hexString: "979797")
    
    var infoType: AppInfoType
    var shouldIncludeSeparator: Bool = true {
        didSet {
            self.setupViews()
        }
    }
    
    init(_ infoType: AppInfoType) {
        
        self.infoType = infoType

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
        self.addSubviews([infoButton, separatorView])
    }
    
    private func layoutViews() {
        layoutInfoButton()
        layoutSeparatorView()
    }
    
    private func layoutInfoButton() {
        infoButton.snp.makeConstraints { infoButton in
            infoButton.edges.equalToSuperview()
            infoButton.centerY.equalToSuperview()
        }
    }
    private func layoutSeparatorView() {
        separatorView.snp.makeConstraints { separatorView in
            separatorView.bottom.equalTo(self.snp.bottom)
            separatorView.height.equalTo(separatorHeight)
            separatorView.width.equalTo(self).multipliedBy(separatorMultipliedWidth)
            separatorView.centerX.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupInfoButton()
        setupSeparatorView()
    }
    
    private func setupInfoButton() {
        infoButton.setTitle(infoType.rawValue, for: .normal)
        infoButton.setTitleColor(UIColor(hexString: "7b7b7b"), for: .normal)
        infoButton.titleLabel?.font = Fonts.h5(weight: .bold)
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = separatorBackgroundColor
        separatorView.isHidden = !shouldIncludeSeparator
    }
}
