//
//  AdminAnalyticsViewContainer.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 01/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class AdminAnalyticsViewContainer: UIView {
    
    struct AdminAnalyticsViewContainerData {
        let title: String
        let count: String
    }
    
    private let mainStackView = UIStackView()
    
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
        setupStackView()
    }
    
    private func setupStackView() {
        mainStackView.alignment = .fill
        mainStackView.axis = .horizontal
        mainStackView.spacing = Metrics.triplePadding
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
    }
    
    private func layoutViews() {
        mainStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
            make.bottom.top.equalToSuperview()
        }
    }
    
    func configure(with analyticsData: [AdminAnalyticsViewContainerData]) {
        mainStackView.removeAllSubviews()
        for data in analyticsData {
            addAnalyticsToStackView(with: data)
        }
    }
    
    private func addAnalyticsToStackView(with data: AdminAnalyticsViewContainerData) {
        let analyticsView = AdminAnalyticsView()
        analyticsView.configure(with: data)
        mainStackView.addArrangedSubview(analyticsView)
    }
}

final class AdminAnalyticsView: UIView {
    
    let titleLabel = UILabel()
    let countLabel = UILabel()
    
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
        setupTitleLabel()
        setupCountLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.h7(weight: .bold)
        titleLabel.textColor = .dizzyBlue
        titleLabel.textAlignment = .natural
    }
    
    private func setupCountLabel() {
        countLabel.numberOfLines = 1
        countLabel.textColor = .dizzyBlue
        countLabel.textAlignment = .center
        countLabel.font = Fonts.h1(weight: .bold)
    }
    
    private func addSubviews() {
        addSubviews([titleLabel, countLabel])
    }
    
    private func layoutViews() {
        countLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(Metrics.doublePadding)
            make.leading.trailing.equalTo(countLabel)
        }
    }
    
    func configure(with data: AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData) {
        titleLabel.text = data.title
        countLabel.text = data.count
    }
}
