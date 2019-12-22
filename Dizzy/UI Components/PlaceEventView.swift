//
//  PlaceEventView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class PlaceEventView: UIView {

    let eventLabel = UILabel()
    let eventFontColor = UIColor(hexString: "#1fcc4d")
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(eventLabel)
    }
    
    private func layoutViews() {
        eventLabel.snp.makeConstraints { eventLabel in
            eventLabel.top.equalToSuperview().offset(Metrics.tinyPadding)
            eventLabel.bottom.equalToSuperview().inset(Metrics.tinyPadding)
            eventLabel.leading.equalToSuperview().offset(Metrics.mediumPadding)
            eventLabel.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
        
        eventLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupViews() {
        backgroundColor = UIColor(hexString: "#e3e3e3")
        layer.cornerRadius = 9
        setupEventLabel()
    }
    
    private func setupEventLabel() {
        eventLabel.font = Fonts.h9(weight: .medium)
        eventLabel.textColor = eventFontColor
    }
    
    public func setEventText(_ eventText: String?) {
        eventLabel.text = eventText
    }
}