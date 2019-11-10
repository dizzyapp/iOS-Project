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
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(Metrics.doublePadding)
        }
    }
    
    private func addSubviews() {
        makeCard()
        cardContainerView.addSubview(tableView)
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserPlaceCell.self)
    }
    
    private func bindViewModel() {
        viewModel.loading.bind { [weak self] loading in
            loading ? self?.showSpinner() : self?.hideSpinner()
        }
        
        viewModel.userPlaces.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension AdminPlacesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserPlaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = viewModel.data(at: indexPath)
        cell.configure(with: data)
        return cell
    }
}
