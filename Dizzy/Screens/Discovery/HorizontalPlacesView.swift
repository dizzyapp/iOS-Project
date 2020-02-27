//
//  HorizontalPlacesView.swift
//  Dizzy
//
//  Created by Menashe, Or on 27/02/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

protocol HorizontalPlacesViewDataSource: class {
    func numberOfPlaces() -> Int
    func placeInfoForIndexPath(_ indexPath: IndexPath) -> PlaceInfo
}

class HorizontalPlacesView: UIView {
    
    private let placesCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: HorizontalPlacesCollectionViewFlowLayout())
    weak var dataSource: HorizontalPlacesViewDataSource?
    let cellId = "horizontalPlaceCell"

    init() {
        super.init(frame: .zero)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews() {
        addSubview(placesCollectionView)
        placesCollectionView.snp.makeConstraints { collectionView in
            collectionView.edges.equalToSuperview()
            collectionView.height.equalTo(100)
        }
    }
    
    func setupViews() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        placesCollectionView.backgroundColor = .clear
        placesCollectionView.register(HorizontalPlacesViewCell.self, forCellWithReuseIdentifier: cellId)
        placesCollectionView.dataSource = self
    }
    
    func reloadData() {
        placesCollectionView.reloadData()
    }
    
}

extension HorizontalPlacesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfPlaces() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HorizontalPlacesViewCell,
        let placeInfo = dataSource?.placeInfoForIndexPath(indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.setPlaceInfo(placeInfo)
        return cell
    
    }
    
}
