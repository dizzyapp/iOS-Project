//
//  MapSearchVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 22/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class MapSearchVC: ViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "enter your place".unlocalized
        searchBar.barStyle = .default
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private let tableView = UITableView(frame: .zero)
    private var workItem: DispatchWorkItem?
    
    private let viewModel: MapSearchVMType
    
    init(viewModel: MapSearchVMType) {
        self.viewModel = viewModel
        super.init()
        setupTableView()
        addSubviews()
        layoutViews()
        setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        setupeSearchBar()
        view.addSubviews([searchBar, tableView])
    }
    
    private func setupeSearchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    private func layoutViews() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        searchBar.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(90)
            make.top.equalTo(statusBarHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MapSearchTableViewCell.self)
    }
    
    private func setupNavigation() {
        navigationItem.hidesBackButton = true
    }

    @objc func cancelButtonPressed() {
        viewModel.closeButtonPressed()
    }
}

extension MapSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.itemAt(indexPath) else { return UITableViewCell () }
        let cell: MapSearchTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
}

extension MapSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.workItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.filter(filterString: searchText)
            self.tableView.reloadData()
        }
        
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: workItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.closeButtonPressed()
    }
}
