//
//  ReservationCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 03/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class ReservationCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let numberOfPeopleLabel = UILabel()
    let iconImageView = PlaceImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: ReservationData) {
        
    }
}
