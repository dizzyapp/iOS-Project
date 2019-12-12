//
//  ReservationsTitleView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class ReservationsTitleView: UIView {

    let mainStackView = UIStackView()
    let leadingLabel = UILabel()
    let trealingLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        addSubviews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupLeadingLabel()
        setupTrealingLabel()
        setupStackView()
    }
    
    private func setupLeadingLabel() {
        leadingLabel.text = "Reservations".localized
        leadingLabel.font = Fonts.h1(weight: .bold)
        leadingLabel.textAlignment = .natural
    }
    
    private func setupTrealingLabel() {
        trealingLabel.text = "# of People".localized
        trealingLabel.font = Fonts.h7(weight: .bold)
        trealingLabel.textAlignment = .oppositeNatural
    }
    
    private func setupStackView() {
        mainStackView.axis = .horizontal
        mainStackView.alignment = .fill
        mainStackView.addArrangedSubview(leadingLabel)
        mainStackView.addArrangedSubview(trealingLabel)
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
    }
    
    private func layoutViews() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
