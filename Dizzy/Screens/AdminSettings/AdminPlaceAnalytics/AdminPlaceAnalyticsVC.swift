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
    private let analyticsView = AnalyticsViewContainer()
    
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
        makeCard()
        setupTitleLabel()
//        setupTableView()
        setupNavigationView()
    }
    
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(AdminPlaceAnalyticCell.self)
//        tableView.separatorStyle = .none
//    }
    
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
        cardContainerView.addSubview(analyticsView)
    }
    
    private func layoutViews() {
//        tableView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(Metrics.oneAndHalfPadding)
//            make.leading.trailing.equalToSuperview()
//            make.bottomMargin.equalToSuperview()
//        }
        analyticsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.doublePadding)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        analyticsView.configure(with: viewModel.analyticsData)
    }
    
    @objc private func backPressed() {
        viewModel.delegate?.adminPlaceAnalyticsBackPressed(viewModel)
    }
}

//extension AdminPlaceAnalyticsVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfItems()
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: AdminPlaceAnalyticCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        let cellData = viewModel.item(at: indexPath)
//        cell.configure(with: cellData)
//        return cell
//    }
//}
