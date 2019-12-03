//
//  AdminPlaceAnalyticsVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class AdminPlaceAnalyticsVC: ViewController, CardVC {
    
    var cardContainerView = UIView()
    
    private let viewModel: AdminPlaceAnalyticsVMType
    private let tableView = UITableView()
    private let titleLabel = UILabel()
    private let analyticsView = AdminAnalyticsViewContainer()
    private let reservationsTitleView = ReservationsTitleView()

    private lazy var tableViewDataSource = ReservationsDataSource(viewModel: viewModel)

    init(viewModel: AdminPlaceAnalyticsVMType) {
        self.viewModel = viewModel
        super.init()
        setupViews()
        addSubviews()
        layoutViews()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        reservationsTitleView.isHidden = true
        makeCard()
        setupTitleLabel()
        setupTableView()
        setupNavigationView()
    }
    
    private func setupTableView() {
        tableView.delegate = tableViewDataSource
        tableView.dataSource = tableViewDataSource
        tableView.register(ReservationCell.self)
        tableView.separatorStyle = .none
    }
    
    private func setupNavigationView() {
        let backButton = UIButton(type: .system)
        backButton.setImage(Images.backArrowIcon(), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        navigationItem.titleView = titleLabel
    }
    
    private func setupTitleLabel() {
        titleLabel.text = viewModel.placeName
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.h2()
        titleLabel.textColor = .white
    }

    private func addSubviews() {
        cardContainerView.addSubviews([analyticsView, reservationsTitleView, tableView])
    }
    
    private func layoutViews() {
        analyticsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.doublePadding)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
        
        reservationsTitleView.snp.makeConstraints { make in
            make.top.equalTo(analyticsView.snp.bottom).offset(Metrics.triplePadding)
            make.leading.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            make.trailing.equalToSuperview().inset(Metrics.oneAndHalfPadding)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(reservationsTitleView.snp.bottom).offset(Metrics.oneAndHalfPadding)
            make.leading.trailing.equalTo(reservationsTitleView)
            make.bottomMargin.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        analyticsView.configure(with: viewModel.analyticsData)
        
        viewModel.reservationsData.bind { [weak self] reservationsData in
            self?.tableView.reloadData()
            self?.reservationsTitleView.isHidden = reservationsData.isEmpty
        }
    }
    
    @objc private func backPressed() {
        viewModel.delegate?.adminPlaceAnalyticsBackPressed(viewModel)
    }
}
