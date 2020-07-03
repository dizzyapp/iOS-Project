//
//  TodayEventCell.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 03/07/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

final class TodayEventCell: UITableViewCell {
    
    let todayEventView = TodayEventView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubviews([todayEventView])
        
        todayEventView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: BigImageHorizontalViewModelType) {
        todayEventView.configure(with: viewModel)
    }
}
