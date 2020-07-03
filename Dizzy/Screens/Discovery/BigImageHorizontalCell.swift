//
//  BigImageHorizontalCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 30/06/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

final class BigImageHorizontalCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h9(weight: .bold) //NTD
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13() //NTD
        label.numberOfLines = 1
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubviews([imageView, titleLabel, subtitleLabel])
        layoutViews()
    }
    
    private func layoutViews() {
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(Metrics.mediumPadding)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    func configure(with data: BigImageHorizontalViewModel.Data) {
        
        if let url = URL(string: data.imageURL) {
            imageView.kf.setImage(with: url) //NTD
        }
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}
