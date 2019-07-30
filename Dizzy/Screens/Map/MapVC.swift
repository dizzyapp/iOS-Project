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
    private var googleMap: MapType
    private var locationLabel = LocationLabel()
    private let currentLocationButton = UIButton()
    
    init(viewModel: MapVMType, googleMap: MapType) {
        self.viewModel = viewModel
        self.googleMap = googleMap
        super.init()
        bindViewModel()
        addSubviews()
        layoutSubviews()
        setupViews()
        setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func addSubviews() {
        view = googleMap.mapView
        view.addSubview(currentLocationButton)
    }
    
    private func setupViews() {
        setupCurrentLocationButton()
    }
    
    private func setupCurrentLocationButton() {
        currentLocationButton.setImage(UIImage(named: "current_location_icon"), for: .normal)
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonPressed), for: .touchUpInside)
    }
    
    private func layoutSubviews() {
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Metrics.doublePadding)
            make.right.equalToSuperview().inset(Metrics.doublePadding)
        }
    }

    private func bindViewModel() {
        viewModel.selectedLocation.bind { [weak self] location  in
            guard let self = self, let location = location else { return }
            self.locationLabel.isHidden = false
            self.googleMap.changeMapFocus(location, zoom: self.viewModel.zoom)
        }

        viewModel.currentAddress.bind { [weak self] address in
            let placeText = address?.city ?? address?.country ?? "TextForNoPlace".localized
            self?.locationLabel.setText(placeText)
        }
        
        viewModel.marks.bind(shouldObserveIntial: true) { [weak self] marks in
            self?.googleMap.addMarks(marks)
        }
    }
    
    private func setupNavigation() {
        navigationItem.titleView = locationLabel
        locationLabel.isHidden = true
        let closeButton = UIButton().navigaionCloseButton
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeBarButton

        let searchButton = UIButton().roundedSearchButton
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
    
    @objc private func currentLocationButtonPressed() {
        viewModel.resetMapToInitialState()
    }
}
