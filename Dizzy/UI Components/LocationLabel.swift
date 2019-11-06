//
//  LocationLabel.swift
//  Dizzy
//
//  Created by Or Menashe on 4/8/19.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

protocol LocationLabelDelegate: class {
    func locationLabelPressed()
}

class LocationLabel: UIView {
    weak var delegate: LocationLabelDelegate?
    private let textLabel = UILabel()
    private let textLabelHorizontalPadding = CGFloat(4)
    private let cornersRadius = CGFloat(16)
    private let backgroundAlpha = CGFloat(0.9)

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
            textLabel.top.equalToSuperview().offset(textLabelHorizontalPadding)
            textLabel.leading.equalToSuperview().offset(Metrics.padding)
            textLabel.trailing.equalToSuperview().offset(-Metrics.padding)
            textLabel.bottom.equalToSuperview().offset(-textLabelHorizontalPadding)
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.white.withAlphaComponent(backgroundAlpha)
        self.layer.cornerRadius = cornersRadius
        setupTextLabel()
    }
    
    private func setupTextLabel() {
        textLabel.numberOfLines = 1
        textLabel.font = Fonts.h5()
        textLabel.textColor = .blue
        textLabel.contentMode = .center
    }

    func setText(_ text: String) {
        textLabel.text = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard delegate != nil else {
           return
        }
        
        alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1
        delegate?.locationLabelPressed()
    }
}
