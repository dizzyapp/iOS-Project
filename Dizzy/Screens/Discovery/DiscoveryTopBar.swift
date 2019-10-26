//
//  DiscoveryTopBar.swift
//  Dizzy
//
//  Created by Or Menashe on 4/8/19.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

protocol DiscoveryTopBarDelegate: class {
    func mapButtonPressed()
    func menuButtonPressed()
    func locationLablePressed()
}

class DiscoveryTopBar: UIView {

    weak var delegate: DiscoveryTopBarDelegate?
    private let mapButton = UIButton()
    private let locationNameLabel = LocationLabel()
    private let menuButton = UIButton()
    
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
        setupMapButton()
        setupLocationLabel()
        setupMenuButton()
    }
    
    private func setupMapButton() {
        mapButton.setImage(Images.discoveryMapIcon(), for: .normal)
        mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
    }
    
    private func setupLocationLabel() {
        locationNameLabel.delegate = self
    }
    
    private func setupMenuButton() {
        menuButton.setImage(Images.menuIcon(), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
    }
    
    @objc private func locationNamePressed() {
        delegate?.locationLablePressed()
    }
    
    @objc private func mapButtonPressed() {
        delegate?.mapButtonPressed()
    }
    
    @objc private func menuButtonPressed() {
        delegate?.menuButtonPressed()
    }
    
    public func setLocationName(_ name: String) {
        locationNameLabel.setText(name)
    }
}

extension DiscoveryTopBar: LocationLabelDelegate {
    func locationLabelPressed() {
        delegate?.locationLablePressed()
    }
}
