//
//  MapVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps

class MapVC: ViewController {
    
    private var viewModel: MapVMType
    private var googleMap: MapType
    private var locationLabel = LocationLabel()
    private let currentLocationButton = UIButton()
    private let placeInfoView = PlaceInfoView()
    var placeInfoViewVisibleStateConstraint: Constraint?
    var placeInfoViewHiddenStateConstraint: Constraint?
    
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
        googleMap.mapView.delegate = self
        view = googleMap.mapView
        view.addSubviews([currentLocationButton, placeInfoView])
    }
    
    private func setupViews() {
        setupCurrentLocationButton()
        setupPlaceInfoView()
    }
    
    private func setupCurrentLocationButton() {
        currentLocationButton.setImage(UIImage(named: "current_location_icon"), for: .normal)
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonPressed), for: .touchUpInside)
    }
    
    private func setupPlaceInfoView() {
        placeInfoView.alpha = 0
        placeInfoView.layer.cornerRadius = 15
        placeInfoView.delegate = self
    }
    
    private func layoutSubviews() {
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(placeInfoView.snp.top).offset(-Metrics.doublePadding)
            make.right.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        placeInfoView.snp.makeConstraints { placeInfoView in
            placeInfoView.leading.equalToSuperview().offset(Metrics.padding)
            placeInfoView.trailing.equalToSuperview().offset(-Metrics.padding)
            placeInfoViewVisibleStateConstraint = placeInfoView.bottom.equalTo(view.snp.bottomMargin).offset(-Metrics.padding).priority(1).constraint
            placeInfoViewHiddenStateConstraint = placeInfoView.top.equalTo(view.snp.bottom).priority(999).constraint
        }
    }

    private func bindViewModel() {
        viewModel.selectedLocation.bind { [weak self] location  in
            guard let self = self, let location = location else { return }
            self.googleMap.showUserLocation = true
            self.locationLabel.isHidden = false
            self.googleMap.changeMapFocus(location, zoom: self.viewModel.zoom)
        }

        viewModel.currentAddress.bind { [weak self] address in
            let placeText = address?.city ?? address?.country ?? "Unknown Place".localized
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

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let markerLocation =  Location(latitude: marker.position.latitude, longitude: marker.position.longitude)
        guard let placeInfo = viewModel.getPlaceInfo(byLocation: markerLocation) else {
            return false
        }
        placeInfoView.setPlaceInfo(placeInfo, currentAppLocation: viewModel.currentLocation.value)
        showPlaceInfoViewWithAnimation()
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hidePlaceInfoViewWithAnimation()
    }
    
    private func hidePlaceInfoViewWithAnimation() {
        guard !isPlaceInfoViewHidden() else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.placeInfoViewVisibleStateConstraint?.update(priority: 1)
            self.placeInfoViewHiddenStateConstraint?.update(priority: 999)
            self.placeInfoView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func showPlaceInfoViewWithAnimation() {
        guard isPlaceInfoViewHidden() else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.placeInfoViewVisibleStateConstraint?.update(priority: 999)
            self.placeInfoViewHiddenStateConstraint?.update(priority: 1)
            self.placeInfoView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func isPlaceInfoViewHidden() -> Bool {
        return placeInfoView.alpha == 0
    }
}

extension MapVC: PlaceInfoViewDelegate {
    
    func placeInfoViewDidPressDetails(_ placeInfo: PlaceInfo) {
        viewModel.placeDetailsPressed(placeInfo)
    }
    
    func placeInfoViewDidPressIcon(_ placeInfo: PlaceInfo) {
        viewModel.placeIconPressed(placeInfo)
    }
    
    func placeInfoDidPressReservationButton(_ placeInfo: PlaceInfo) {
        viewModel.requestATablePressed(placeInfo)
    }
}
