//
//  AdminPlacesVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class AdminPlacesVC: ViewController, CardVC, LoadingContainer {
    
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    var cardContainerView: UIView = UIView()
    
    private let viewModel: AdminPlacesVMType
    private let tableView = UITableView()
    private let titleLabel = UILabel()
    
    init(viewModel: AdminPlacesVMType) {
        self.viewModel = viewModel
        super.init()
        addSubviews()
        layoutSubviews()
        setupViews()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutSubviews() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            make.leading.equalToSuperview().offset(Metrics.mediumPadding)
            make.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.oneAndHalfPadding)
            make.leading.trailing.equalTo(titleLabel)
            make.bottomMargin.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        makeCard()
        cardContainerView.addSubviews([tableView,titleLabel])
    }
    
    private func setupViews() {
        setupTableView()
        setupTitleLabel()
        setupNavigationView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminPlaceCell.self)
        tableView.separatorStyle = .none
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.h3(weight: .bold)
        titleLabel.textColor = .dizzyBlue
        titleLabel.textAlignment = .center
        titleLabel.text = "Select your business".localized
    }
    
    private func setupNavigationView() {
        let backButton = UIButton(type: .system)
        backButton.setImage(Images.backArrowIcon(), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func bindViewModel() {
        viewModel.loading.bind { [weak self] loading in
            loading ? self?.showSpinner() : self?.hideSpinner()
        }
        
        viewModel.userPlaces.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func backPressed() {
        viewModel.delegate?.adminPlaceVMBackPressed(viewModel)
    }
}

extension AdminPlacesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AdminPlaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = viewModel.place(at: indexPath)
        cell.configure(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}
