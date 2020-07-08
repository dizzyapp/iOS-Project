//
//  BigImageHorizontalCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 30/06/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

protocol BigImageHorizontalCellViewModelType {
    var imageURL: String { get }
    var title: String { get }
    var subtitle: String { get }
    var imageDescription: Observable<String> { get }
    var description: String { get }
    var placeHolderImage: UIImage { get }
    var placeId: String { get }
}

final class BigImageHorizontalCell: UICollectionViewCell {
    
    weak var delegate: DiscoveryPlaceCellDelegate?
    var placeId = ""

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13(weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13()
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13()
        return label
    }()
    
    let imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13()
        label.textColor = .lightGray
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackview = UIStackView(frame: .zero)
        stackview.alignment = .fill
        stackview.axis = .vertical
        return stackview
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 25.0
        imageView.clipsToBounds = true
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubviews([imageView, labelStackView])
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCell)))
        labelStackView.addSubviews(imageDescriptionLabel, descriptionLabel, titleLabel, subtitleLabel)
        layoutViews()
    }
    
    private func layoutViews() {
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.padding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(imageView.snp.height)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Metrics.mediumPadding)
            make.leading.equalToSuperview().offset(Metrics.mediumPadding)
            make.trailing.equalToSuperview().inset(Metrics.mediumPadding)
        }
    }
        
    func configure(with data: BigImageHorizontalCellViewModelType) {
        
        if let url = URL(string: data.imageURL) {
            imageView.kf.setImage(with: url, placeholder: data.placeHolderImage)
        } else {
            imageView.image  = data.placeHolderImage
        }
        
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        descriptionLabel.text = data.description
        imageDescriptionLabel.text  = "..."
        placeId = data.placeId
        
        data.imageDescription.bind { [weak self] text in
            self?.imageDescriptionLabel.text = text
        }
    }
    
    @objc private func didTapCell() {
        delegate?.discoveryPlaceCellDidPressDetails(withPlaceId: placeId)
    }
}