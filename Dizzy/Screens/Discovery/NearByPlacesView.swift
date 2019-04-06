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
}

protocol NearByPlacesViewDelegate: class {
    func didPressPlaceIcon(AtIndexPath indexPath: IndexPath)
    func didPressPlaceDetails(AtIndexPath indexPath: IndexPath)
}

class NearByPlacesView: UIView {
    weak var delegate: NearByPlacesViewDelegate?
    weak var dataSource: NearByPlacesViewDataSource?
    
    private let searchButton = UIButton()
    private let titleLabel = UILabel()
    private let placesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    private let cellIDentifier = "DiscoveryPlaceCell"
    
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
            searchButton.top.equalToSuperview().offset(Metrics.doublePadding)
        }
        
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(Metrics.doublePadding)
            titleLabel.centerX.equalToSuperview()
            titleLabel.trailing.lessThanOrEqualTo(searchButton).offset(-Metrics.padding)
            titleLabel.leading.greaterThanOrEqualToSuperview().offset(Metrics.padding)
        }
        
        placesCollectionView.snp.makeConstraints { placesCollectionView in
            placesCollectionView.top.equalTo(titleLabel).offset(2 * Metrics.doublePadding)
            placesCollectionView.leading.equalToSuperview().offset(Metrics.doublePadding)
            placesCollectionView.trailing.equalToSuperview().offset(-Metrics.doublePadding)
            placesCollectionView.bottom.equalToSuperview()
        }
    }
    
    private func setupViews() {
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
        titleLabel.font = Fonts.h9()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.text = "Discover"
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
        print("menash logs - arrived here? \(itemsInSection)")
        return itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("menash logs - arrived here")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDentifier, for: indexPath) as? DiscoveryPlaceCell,
            let placeInfo = self.dataSource?.itemForIndexPath(indexPath) else {
            print("could not dequeue \(cellIDentifier) or datasource is nil")
            return UICollectionViewCell()
        }
        
        cell.setPlaceInfo(placeInfo)
        return cell
    }
}
