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
    
    let topBar = DiscoveryTopBar()
    let themeImageView = UIImageView()
    let nearByPlacesView = NearByPlacesView()
    var viewModel: DiscoveryVMType
    
    let nearByPlacesViewCornerRadius = CGFloat(5)
    
    init(viewModel: DiscoveryVMType) {
        self.viewModel = viewModel
        super.init()
        addSubviews()
        layoutViews()
        setupViews()
        bindViewModel()
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.view.addSubviews([themeImageView, topBar, nearByPlacesView])
    }
    
    private func layoutViews() {
        
        topBar.snp.makeConstraints { topBar in
            topBar.top.equalTo(view.snp.topMargin)
            topBar.trailing.leading.equalToSuperview()
        }
        
        themeImageView.snp.makeConstraints { themeImageView in
            
            themeImageView.top.leading.trailing.equalToSuperview()
            themeImageView.bottom.equalTo(view.snp.bottom)
        }
        
        nearByPlacesView.snp.makeConstraints { nearByPlacesView in
            
            nearByPlacesView.height.equalTo(view.snp.height).multipliedBy(0.55)
            nearByPlacesView.leading.equalToSuperview().offset(5)
            nearByPlacesView.trailing.equalToSuperview().offset(-5)
            nearByPlacesView.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
    }
    
    private func bindViewModel() {
        viewModel.currentCity.bind(shouldObserveIntial: true, observer: { [weak self] currentCity in
            guard !currentCity.isEmpty else {
                self?.topBar.setLocationName("getting location")
                return
            }
            self?.topBar.setLocationName(currentCity)
        })
        
        viewModel.currentLocation.bind { _ in
            self.reloadData()
        }
    }
    
    private func setupViews() {
        
        setupThemeImageView()
        setupNearByPlacesView()
        setupTopBarView()
    }
    
    private func setupTopBarView() {
        topBar.delegate = self
    }
    
    private func setupThemeImageView() {
        themeImageView.contentMode = .scaleAspectFill
        themeImageView.image = Images.discoveryThemeImage()
    }
    
    private func setupNearByPlacesView() {
        nearByPlacesView.dataSource = self
        nearByPlacesView.delegate = self
        nearByPlacesView.reloadData()
    }
    
    public func showTopBar() {
        self.topBar.isHidden = false
    }
    
    public func hideTopBar() {
        self.topBar.isHidden = true
    }
}

extension DiscoveryVC: NearByPlacesViewDataSource {
    func getCurrentLocation() -> Location? {
        return viewModel.currentLocation.value
    }
    
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

extension DiscoveryVC: DiscoveryTopBarDelegate {
    func mapButtonPressed() {
        viewModel.mapButtonPressed()
    }
    
    func menuButtonPressed() {
        self.viewModel.menuButtonPressed()
    }
}

extension DiscoveryVC: DiscoveryVMDelegate {
    func reloadData() {
        nearByPlacesView.showSpinner()
    }
    
    func allPlacesArrived() {
        nearByPlacesView.hideSpinner()
        nearByPlacesView.reloadData()
    }
}

extension DiscoveryVC: NearByPlacesViewDelegate {
    func didPressPlaceIcon(atIndexPath indexPath: IndexPath) {
        
    }
    
    func didPressPlaceDetails(atIndexPath indexPath: IndexPath) {
        viewModel.placeCellDetailsPressed(atIndexPath: indexPath)
    }
}
