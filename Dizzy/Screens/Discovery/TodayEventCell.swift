//
//  TodayEventCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 03/07/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

final class TodayEventCell: UITableViewCell, DiscoveryCell {
    
    weak var delegate: DiscoveryPlaceCellDelegate?
    private var dataSource: [TodayEventCell.ViewModel]?

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HorizontalPlacesCollectionViewFlowLayout(itemSize: CGSize(width: 140, height: 230)))
        collectionView.register(BigImageHorizontalCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubviews([collectionView])
        layoutView()
    }
    
    private func layoutView() {
        contentView.snp.makeConstraints { make in
            make.height.width.equalTo(250)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with dataType: NearByDataType) {
        guard case let NearByDataType.todayEvent(data: data) = dataType else { return }
        configure(with: data)
    }
    
    private func configure(with data: [TodayEventCell.ViewModel]) {
        dataSource = data
        collectionView.reloadData()
    }
}

extension TodayEventCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = dataSource?[indexPath.row] else { return UICollectionViewCell() }
        let cell: BigImageHorizontalCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: data)
        cell.delegate = delegate
        return cell
    }
}

extension TodayEventCell {
    struct ViewModel: BigImageHorizontalCellViewModelType {
        var placeId: String
        let imageDescription = Observable<String>("")
        let description: String
        let imageURL: String
        let title: String
        let subtitle: String
        let placeHolderImage: UIImage = Images.getTodayEventPlaceHolderImage()
    }
}
