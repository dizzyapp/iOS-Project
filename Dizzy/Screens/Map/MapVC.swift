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
        layoutViews()
        addMarks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view = googleMap.mapView
    }
    
    private func layoutViews() {
  
    }
    
    private func bindViewModel() {
        viewModel.currentLocation.bind { [weak self] location  in
            guard let self = self, let location = location else { return }
            self.googleMap.changeMapCenter(location, zoom: 13.0)
        }
        
        viewModel.currentAddress.bind { [weak self] (address) in
            self?.locationLabel.setText(address?.city ?? "")
            self?.setupNavigation()
        }
    }
    
    private func addMarks() {
        let marks = viewModel.places.map { return GoogleMap.Marks(title: $0.name, snippet: $0.address, location: $0.location) }
        googleMap.addMarks(marks)
    }
    
    private func setupNavigation() {
        navigationItem.titleView = locationLabel
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16.0
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func close() {
        viewModel.close()
    }
}
