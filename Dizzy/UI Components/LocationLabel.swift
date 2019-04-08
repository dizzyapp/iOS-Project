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
    
    let textLabel = UILabel()
    let horizontalPadding = CGFloat(4)
    let cornersRadius = CGFloat(13)
    let backgroundAlpha = CGFloat(0.5)

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
        self.addSubviews([textLabel])
    }
    
    private func layoutViews() {
        textLabel.snp.makeConstraints { textLabel in
            textLabel.top.equalToSuperview().offset(horizontalPadding)
            textLabel.leading.equalToSuperview().offset(Metrics.padding)
            textLabel.trailing.equalToSuperview().offset(-Metrics.padding)
            textLabel.bottom.equalToSuperview().offset(-horizontalPadding)
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        self.layer.cornerRadius = cornersRadius
        setupTextLabel()
    }
    
    private func setupTextLabel() {
        textLabel.numberOfLines = 1
        textLabel.font = Fonts.h8()
        textLabel.textColor = .white
        textLabel.contentMode = .center
    }
    
    public func setText(_ text: String) {
        textLabel.text = text
    }
}
