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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h12(weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13(weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h10(weight: .medium)
        label.numberOfLines = 2
        label.textColor = .blue
        return label
    }()
    
    let imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.h13(weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    let reserveATableButton: UIButton = {
        let reservationButton = UIButton(type: .system)
        reservationButton.setTitle("RESERVE A TABLE", for: .normal)
        return reservationButton
    }()
    
    let labelStackView: UIStackView = {
        let stackview = UIStackView(frame: .zero)
        stackview.alignment = .fill
        stackview.spacing = 0.2
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
        imageView.layer.cornerRadius = 4.5
        imageView.clipsToBounds = true
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubviews([imageView, labelStackView])
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCell)))
        labelStackView.addSubviews(imageDescriptionLabel, descriptionLabel, titleLabel, subtitleLabel, reserveATableButton)
        layoutViews()
    }
    
    private func layoutViews() {
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.padding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
            make.width.equalTo(180)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Metrics.tinyPadding)
            make.leading.equalToSuperview().offset(Metrics.pixelPadding)
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
        
        data.imageDescription.bind(shouldObserveIntial: true) { [weak self] text in
            guard !text.isEmpty else { return }
            self?.imageDescriptionLabel.text = text
        }
    }
    
    @objc private func didTapCell() {
        delegate?.discoveryPlaceCellDidPressDetails(withPlaceId: placeId)
    }
}
