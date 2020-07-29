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
    func discoveryPlaceCellDidPressReserveATable(withPlaceInfo placeInfo: PlaceInfo)
}

class DiscoveryPlaceCell: UITableViewCell, DiscoveryCell {
    
    let placeImageHeight = 300
    let placeEventViewSpacing = 20
    let placeInfoView = PlaceInfoView()
    let placeImageView = UIImageView()
    let placeEventView = PlaceEventView()

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
        addSubviews([placeInfoView, placeImageView, placeEventView])
    }
    
    private func layoutViews() {
        self.layoutPlaceImageView()
        self.layoutPlaceEventView()
        self.layoutPlaceInfo()
    }
    
    func layoutPlaceImageView() {
        placeImageView.snp.makeConstraints { placeImageView in
            placeImageView.top.leading.trailing.equalToSuperview()
            placeImageView.height.equalTo(placeImageHeight)
        }
    }
    
    func layoutPlaceEventView() {
        placeEventView.snp.makeConstraints { placeEventView in
            placeEventView.top.equalTo(placeImageView.snp.top).offset(placeEventViewSpacing)
            placeEventView.leading.equalTo(placeImageView.snp.leading).offset(placeEventViewSpacing)
        }
    }
        
    private func layoutPlaceInfo() {
        placeInfoView.snp.makeConstraints { placeInfoView in
            placeInfoView.bottom.leading.trailing.equalToSuperview()
            placeInfoView.top.equalTo(placeImageView.snp.bottom)
        }
    }
    
    private func setupViews() {
        backgroundColor = .clear
        setupInfoView()
    }
    
    private func setupPlaceImageView() {
        placeImageView.contentMode = .scaleAspectFit
    }
    
    private func setupInfoView() {
        placeInfoView.delegate = self
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
        guard let url = URL.init(string: urlString) else { return }
        placeImageView.kf.setImage(with: url, placeholder: Images.profilePlaceholderIcon())
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
}

extension DiscoveryPlaceCell: PlaceInfoViewDelegate {
    func placeInfoViewDidPressDetails(_ placeInfo: PlaceInfo) {
        delegate?.discoveryPlaceCellDidPressDetails(withPlaceId: placeInfo.id)
    }
    
    func placeInfoViewDidPressIcon(_ placeInfo: PlaceInfo) {
        delegate?.discoveryPlaceCellDidPressIcon(withPlaceId: placeInfo.id)
    }
    
    func placeInfoDidPressReservationButton(_ placeInfo: PlaceInfo) {
        delegate?.discoveryPlaceCellDidPressReserveATable(withPlaceInfo: placeInfo)
    }
}
