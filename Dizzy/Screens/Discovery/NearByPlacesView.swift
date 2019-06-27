//
//  NearByPlacesView.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

protocol NearByPlacesViewDataSource: class {
    func numberOfSections() -> Int
    func numberOfItemsForSection(_ section: Int) -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo
    func getCurrentLocation() -> Location?
}

protocol NearByPlacesViewDelegate: class {
    func didPressPlaceIcon(atIndexPath indexPath: IndexPath)
    func didPressPlaceDetails(atIndexPath indexPath: IndexPath)
}

class NearByPlacesView: UIView, LoadingContainer {
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    weak var delegate: NearByPlacesViewDelegate?
    weak var dataSource: NearByPlacesViewDataSource?
    
    private let searchButton = UIButton()
    private let titleLabel = UILabel()
    private let placesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PlacesListFlowLayout())
    
    private let cellIDentifier = "DiscoveryPlaceCell"
    
    let cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .white
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([searchButton, titleLabel, placesCollectionView])
    }
    
    private func layoutViews() {
        searchButton.snp.makeConstraints { searchButton in
            searchButton.trailing.equalToSuperview().offset(-Metrics.doublePadding)
            searchButton.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            titleLabel.centerX.equalToSuperview()
            titleLabel.trailing.lessThanOrEqualTo(searchButton).offset(-Metrics.padding)
            titleLabel.leading.greaterThanOrEqualToSuperview().offset(Metrics.padding)
        }
        
        placesCollectionView.snp.makeConstraints { placesCollectionView in
            placesCollectionView.top.equalTo(titleLabel).offset(2 * Metrics.doublePadding)
            placesCollectionView.leading.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            placesCollectionView.trailing.equalToSuperview().offset(-Metrics.oneAndHalfPadding)
            placesCollectionView.bottom.equalToSuperview()
        }
    }
    
    private func setupViews() {
        self.layer.cornerRadius = cornerRadius
        setupSearchButton()
        setupTitleLabel()
        setupPlacesCollectionView()
    }
    
    private func setupSearchButton() {
        searchButton.setImage(Images.discoverySearchIcon(), for: .normal)
        searchButton.addTarget(self, action: #selector(didPressSearch), for: .touchUpInside)
    }
    
    @objc private func didPressSearch() {
        
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.h6()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor(hexString: "4C69EF")
        titleLabel.text = "Discover".localized
    }
    
    private func setupPlacesCollectionView() {
        placesCollectionView.allowsSelection = false
        placesCollectionView.dataSource = self
        placesCollectionView.backgroundColor = .white
        
        placesCollectionView.register(DiscoveryPlaceCell.self, forCellWithReuseIdentifier: cellIDentifier)
    }
    
    func reloadData() {
        placesCollectionView.reloadData()
    }
}

extension NearByPlacesView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemsInSection = self.dataSource?.numberOfItemsForSection(section) ?? 0
        return itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDentifier, for: indexPath) as? DiscoveryPlaceCell,
            let placeInfo = self.dataSource?.itemForIndexPath(indexPath) else {
            print("could not dequeue \(cellIDentifier) or datasource is nil")
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setPlaceInfo(placeInfo, currentAppLocation: dataSource?.getCurrentLocation())
        return cell
    }
}

extension NearByPlacesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
}

extension NearByPlacesView: DiscoveryPlaceCellDelegate {
    func discoveryPlaceCellDidPressDetails(_ cell: DiscoveryPlaceCell) {
        guard let indexPath = placesCollectionView.indexPath(for: cell) else { return }
        delegate?.didPressPlaceDetails(atIndexPath: indexPath)
    }
}
