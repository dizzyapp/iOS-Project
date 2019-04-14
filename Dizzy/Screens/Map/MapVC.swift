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
    
    init(viewModel: MapVMType, googleMap: GoogleMapType) {
        self.viewModel = viewModel
        self.googleMap = googleMap
        super.init()
        bindViewModel()
        buildView()
        buildConstraints()
        addMarks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        view = googleMap.mapView
    }
    
    private func buildConstraints() {
  
    }
    
    private func bindViewModel() {
        viewModel.currentLocation.bind { [weak self] location  in
            guard let self = self, let location = location else { return }
            self.googleMap.changeMapCenter(location, zoom: 10.0)
        }
    }
    
    func addMarks() {
        let marks = viewModel.places.map { return GoogleMap.Marks(title: $0.name, snippet: $0.address, location: $0.location) }
        googleMap.addMarks(marks)
    }
}
