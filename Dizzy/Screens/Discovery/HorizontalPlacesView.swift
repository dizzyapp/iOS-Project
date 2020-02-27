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
    func placeInfoForIndex(index: Int) -> PlaceInfo
}

class HorizontalPlacesView: UIView {
    
    private let placesCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: HorizontalPlacesCollectionViewFlowLayout())
    weak var dataSource: HorizontalPlacesViewDataSource?

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
        }
    }
    
    func setupViews() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        placesCollectionView.backgroundColor = .red
    }
    
}

extension HorizontalPlacesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfPlaces() ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        let label = UILabel()
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { label in
            label.edges.equalToSuperview()
        }
        label.text = "sadljkfhlaks"
        return cell
    
    }
    
}
