//
//  DiscoveryCollectionViewCell.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol DiscoveryCell: UITableViewCell {
    func configure(with dataType: NearByDataType)
    var delegate: DiscoveryPlaceCellDelegate? { get set }
}

struct DiscoveryPlaceCellViewModel {
    let location: Location?
    let place: PlaceInfo
}

protocol DiscoveryPlaceCellDelegate: class {
    func discoveryPlaceCellDidPressDetails(withPlaceId placeId: String)
    func discoveryPlaceCellDidPressIcon(withPlaceId placeId: String)
    func discoveryPlaceCellDidPressReserveATable(withPlaceID placeID: String)
}

class DiscoveryPlaceCell: UITableViewCell, DiscoveryCell {
    
    let placeImageHeight = 200
    let placeEventViewSpacing = 10
    let placeInfoView = PlaceInfoView()
    let placeEventView = PlaceEventView()
    
    let placeThemeImageView: UIImageView = {
        let placeImageView = UIImageView()
        placeImageView.contentMode = .scaleToFill
        
        return placeImageView
    }()
    
    weak var delegate: DiscoveryPlaceCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews([placeInfoView, placeThemeImageView, placeEventView])
    }
    
    private func layoutViews() {
        self.layoutPlaceImageView()
        self.layoutPlaceEventView()
        self.layoutPlaceInfo()
    }
    
    func layoutPlaceImageView() {
        placeThemeImageView.snp.makeConstraints { placeImageView in
            placeImageView.top.equalToSuperview().offset(Metrics.doublePadding)
            placeImageView.leading.equalToSuperview().offset(Metrics.padding)
            placeImageView.trailing.equalToSuperview().inset(Metrics.padding)
            placeImageView.height.equalTo(placeImageHeight)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeThemeImageView.layer.cornerRadius = 7
        placeThemeImageView.clipsToBounds = true
        placeThemeImageView.contentMode = .scaleAspectFill
    }
    
    func layoutPlaceEventView() {
        placeEventView.snp.makeConstraints { placeEventView in
            placeEventView.top.equalTo(placeThemeImageView.snp.top).offset(placeEventViewSpacing)
            placeEventView.leading.equalTo(placeThemeImageView.snp.leading).offset(placeEventViewSpacing)
        }
    }
    
    private func layoutPlaceInfo() {
        placeInfoView.snp.makeConstraints { placeInfoView in
            placeInfoView.bottom.equalToSuperview().inset(Metrics.doublePadding)
            placeInfoView.leading.equalToSuperview().offset(Metrics.padding)
            placeInfoView.trailing.equalToSuperview().inset(Metrics.padding)
            placeInfoView.top.equalTo(placeThemeImageView.snp.bottom).inset(Metrics.padding)
        }
    }
    
    private func setupViews() {
        backgroundColor = .clear
        setupInfoView()
        setupPlaceThemeImageView()
    }
    
    private func setupInfoView() {
        placeInfoView.delegate = self
        placeInfoView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
        placeInfoView.setBorder(borderColor: UIColor.lightGray.withAlphaComponent(0.05), cornerRadius: 8)
    }
    
    private func setupPlaceThemeImageView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onThemeImagePress))
        placeThemeImageView.isUserInteractionEnabled = true
        placeThemeImageView.addGestureRecognizer(tapRecognizer)
    }
    
    func setPlaceEventView(placeEvent: String?) {
        placeEventView.setEventText(placeEvent)
        if placeEvent != nil {
            placeEventView.isHidden = false
        } else {
            placeEventView.isHidden = true
        }
    }
    
    func setPlaceImageView(urlString: String) {
        placeThemeImageView.image = Images.getTodayEventPlaceHolderImage()
        guard let url = URL.init(string: urlString) else { return }
        placeThemeImageView.kf.setImage(with: url, placeholder: Images.getTodayEventPlaceHolderImage())
    }
    
    func configure(with dataType: NearByDataType) {
        guard case let .place(viewModel) = dataType else { return }
        setPlaceInfo(viewModel.place, currentAppLocation: viewModel.location)
    }
    
    private func setPlaceInfo(_ placeInfo: PlaceInfo, currentAppLocation: Location?) {
        placeInfoView.setPlaceInfo(placeInfo, currentAppLocation:currentAppLocation)
        setPlaceEventView(placeEvent: placeInfo.event)
        setPlaceImageView(urlString: placeInfo.placeProfileImageUrl ?? "")
    }
    
    @objc func onThemeImagePress() {
        guard let placeId = placeInfoView.placeInfo?.id else { return }
        delegate?.discoveryPlaceCellDidPressDetails(withPlaceId: placeId)
    }
}

extension DiscoveryPlaceCell: PlaceInfoViewDelegate {
    func placeInfoViewDidPressDetails(_ placeInfo: PlaceInfo) {
        delegate?.discoveryPlaceCellDidPressDetails(withPlaceId: placeInfo.id)
    }
    
    func placeInfoViewDidPressIcon(_ placeInfo: PlaceInfo) {
        delegate?.discoveryPlaceCellDidPressIcon(withPlaceId: placeInfo.id)
    }
    
    func placeInfoDidPressReservationButton(_ placeInfo: PlaceInfo) {
        delegate?.discoveryPlaceCellDidPressReserveATable(withPlaceID: placeInfo.id)
    }
}
