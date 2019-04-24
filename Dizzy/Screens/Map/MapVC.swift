//
//  MapVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

class MapVC: ViewController {
    
    private var viewModel: MapVMType
    private var googleMap: GoogleMapType
    private var locationLabel = LocationLabel()
    
    init(viewModel: MapVMType, googleMap: GoogleMapType) {
        self.viewModel = viewModel
        self.googleMap = googleMap
        super.init()
        bindViewModel()
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view = googleMap.mapView
    }

    private func bindViewModel() {
        viewModel.selectedLocation.bind { [weak self] location  in
            guard let self = self, let location = location else { return }
            self.googleMap.changeMapCenter(location, zoom: 13.0)
        }
        
        viewModel.currentAddress.bind { [weak self] address in
            let placeText = address?.city ?? address?.country ?? "TextForNoPlace".unlocalized
            self?.locationLabel.setText(placeText)
            self?.setupNavigation()
        }
        
        viewModel.marks.bind { [weak self] marks in
            self?.googleMap.addMarks(marks)
        }
        
        viewModel.showCancelLocationSelection.bind { [weak self] show in
            self?.locationLabel.setBedgeVisable(show)
        }
        
        locationLabel.onBedgeButtonPressed = { [weak self] in
            self?.viewModel.returnMapToInitialState()
        }
    }
    
    private func setupNavigation() {
        navigationItem.titleView = locationLabel
        let closeButton = UIButton().smallRoundedBlackButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeBarButton
        
        let searchButton = UIButton().smallRoundedBlackButton
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem = searchBarButton
    }
    
    @objc func close() {
        viewModel.close()
    }
    
    @objc func searchButtonPressed() {
        viewModel.searchButtonPressed()
    }
}
