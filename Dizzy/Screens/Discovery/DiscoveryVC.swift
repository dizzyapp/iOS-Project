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
    let nearByPlacesViewPadding = CGFloat(5)
    let nearByPlacesViewHeightRatio = CGFloat(0.55)
    
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
            themeImageView.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        nearByPlacesView.snp.makeConstraints { nearByPlacesView in
            
            nearByPlacesView.height.equalTo(view.snp.height).multipliedBy(nearByPlacesViewHeightRatio)
            nearByPlacesView.leading.equalToSuperview().offset(nearByPlacesViewPadding)
            nearByPlacesView.trailing.equalToSuperview().offset(-nearByPlacesViewPadding)
            nearByPlacesView.bottom.equalTo(view.snp.bottom).offset(-nearByPlacesViewPadding)
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
        view.backgroundColor = .clear
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
        
        nearByPlacesView.showSpinner()
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
