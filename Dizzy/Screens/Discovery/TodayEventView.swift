//
//  TodayEventsView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 30/06/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

final class TodayEventView: UIView {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HorizontalPlacesCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BigImageHorizontalCell.self)
        return collectionView
    }()
    
    private var dataSource: BigImageHorizontalViewModelType?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func configure(with dataSource: BigImageHorizontalViewModelType) {
        self.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews([collectionView])
        layoutView()
    }
    
    private func layoutView() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TodayEventView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = dataSource?.item(at: indexPath) else { return UICollectionViewCell() }
        let cell: BigImageHorizontalCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: data)
        return cell
    }
}
