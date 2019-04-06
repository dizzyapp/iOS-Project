//
//  DiscoveryVC.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

class DiscoveryVC: ViewController {
    
    let themeImageView = UIImageView()
    let nearByPlacesView = NearByPlacesView()
    let viewModel: DiscoveryViewModelType
    
    init(viewModel: DiscoveryViewModelType) {
        self.viewModel = viewModel
        super.init()
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.view.addSubviews([themeImageView, nearByPlacesView])
    }
    
    private func layoutViews() {
        themeImageView.snp.makeConstraints { themeImageView in
            
            themeImageView.top.leading.trailing.equalToSuperview()
            themeImageView.bottom.equalTo(view.snp.centerY)
        }
        
        nearByPlacesView.snp.makeConstraints { nearByPlacesView in
            
            nearByPlacesView.top.equalTo(view.snp.centerY)
            nearByPlacesView.leading.trailing.equalToSuperview()
            nearByPlacesView.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupViews() {
        setupThemeImageView()
        setupNearByPlacesView()
    }
    
    private func setupThemeImageView() {
        themeImageView.contentMode = .center
        themeImageView.image = Images.discoveryThemeImage()
    }
    
    private func setupNearByPlacesView() {
        nearByPlacesView.dataSource = self
        nearByPlacesView.reloadData()
    }
}

extension DiscoveryVC: NearByPlacesViewDataSource {
    func numberOfSections() -> Int {
        return viewModel.numberOfSections()
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return viewModel.numberOfItemsForSection(section)
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return viewModel.itemForIndexPath(indexPath)
    }
}
