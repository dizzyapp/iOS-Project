//
//  DiscoveryTopBar.swift
//  Dizzy
//
//  Created by Or Menashe on 4/8/19.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

class DiscoveryTopBar: UIView {

    let mapButton = UIButton()
    let locationNameLabel = LocationLabel()
    let menuButton = UIButton()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubviews([mapButton, locationNameLabel, menuButton])
    }
    
    func layoutViews() {
        mapButton.snp.makeConstraints { mapButton in
            mapButton.top.equalToSuperview().offset(Metrics.padding)
            mapButton.leading.equalToSuperview().offset(Metrics.doublePadding)
            mapButton.bottom.equalToSuperview().offset(-Metrics.padding)
        }
        
        locationNameLabel.snp.makeConstraints { locationName in
            locationName.center.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints { menuButton in
            menuButton.centerY.equalToSuperview()
            menuButton.trailing.equalToSuperview().offset(-Metrics.doublePadding)
        }
    }
    
    private func setupViews() {
        mapButton.setImage(Images.discoveryMapIcon(), for: .normal)
        
        locationNameLabel.setText("Tel Aviv")
        
        menuButton.setImage(Images.menuIcon(), for: .normal)
    }
    
}
