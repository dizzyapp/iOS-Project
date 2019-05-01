//
//  LocationLabel.swift
//  Dizzy
//
//  Created by Or Menashe on 4/8/19.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

class LocationLabel: UIView {
    
    private let textLabel = UILabel()
    private let badgeButton = UIButton().smallRoundedBlackButton
    private let textLabelHorizontalPadding = CGFloat(4)
    private let cornersRadius = CGFloat(13)
    private let backgroundAlpha = CGFloat(0.5)
    
    var onbadgeButtonPressed: () -> Void = { }

    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        layoutViews()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([textLabel, badgeButton])
    }
    
    private func layoutViews() {
        textLabel.snp.makeConstraints { textLabel in
            textLabel.top.equalToSuperview().offset(textLabelHorizontalPadding)
            textLabel.leading.equalToSuperview().offset(Metrics.padding)
            textLabel.trailing.equalToSuperview().offset(-Metrics.padding)
            textLabel.bottom.equalToSuperview().offset(-textLabelHorizontalPadding)
        }
        
        badgeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top).offset(Metrics.mediumPadding)
            make.centerX.equalTo(self.snp.trailing).offset(Metrics.mediumPadding)
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        self.layer.cornerRadius = cornersRadius
        setupbadge()
        setupTextLabel()
    }
    
    private func setupTextLabel() {
        textLabel.numberOfLines = 1
        textLabel.font = Fonts.h8()
        textLabel.textColor = .white
        textLabel.contentMode = .center
    }
    
    private func setupbadge() {
        badgeButton.isHidden = true
        badgeButton.addTarget(self, action: #selector(badgeButtonButtonPressed), for: .touchUpInside)
    }
    
    @objc func badgeButtonButtonPressed() {
        onbadgeButtonPressed()
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
    
    func setbadgeVisable(_ showbadge: Bool) {
        badgeButton.isHidden = !showbadge
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let modifiedPoint = badgeButton.convert(point, from: self)
        return badgeButton.hitTest(modifiedPoint, with: event) ?? super.hitTest(point, with: event)
    }
}
