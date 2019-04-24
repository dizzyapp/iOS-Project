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
    private let bedgeButton = UIButton().smallRoundedBlackButton
    private let horizontalPadding = CGFloat(4)
    private let cornersRadius = CGFloat(13)
    private let backgroundAlpha = CGFloat(0.5)
    
    var onBedgeButtonPressed: () -> Void = { }

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
        self.addSubviews([textLabel, bedgeButton])
    }
    
    private func layoutViews() {
        textLabel.snp.makeConstraints { textLabel in
            textLabel.top.equalToSuperview().offset(horizontalPadding)
            textLabel.leading.equalToSuperview().offset(Metrics.padding)
            textLabel.trailing.equalToSuperview().offset(-Metrics.padding)
            textLabel.bottom.equalToSuperview().offset(-horizontalPadding)
        }
        
        bedgeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top).offset(Metrics.mediumPadding)
            make.centerX.equalTo(self.snp.trailing).offset(Metrics.mediumPadding)
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        self.layer.cornerRadius = cornersRadius
        setupBedge()
        setupTextLabel()
    }
    
    private func setupTextLabel() {
        textLabel.numberOfLines = 1
        textLabel.font = Fonts.h8()
        textLabel.textColor = .white
        textLabel.contentMode = .center
    }
    
    private func setupBedge() {
        bedgeButton.isHidden = true
        bedgeButton.addTarget(self, action: #selector(bedgeButtonButtonPressed), for: .touchUpInside)
    }
    
    @objc func bedgeButtonButtonPressed() {
        onBedgeButtonPressed()
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
    
    func setBedgeVisable(_ showBedge: Bool) {
        bedgeButton.isHidden = !showBedge
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let modifiedPoint = bedgeButton.convert(point, from: self)
        return bedgeButton.hitTest(modifiedPoint, with: event) ?? super.hitTest(point, with: event)
    }
}
