//
//  CardVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CardVC {
    var cardContainerView: UIView { get set }
    func makeCard()
}

extension CardVC where Self: UIViewController {
    func makeCard() {
        modalPresentationStyle = .overCurrentContext
        view.addSubview(cardContainerView)
        view.backgroundColor = .clear
        
        cardContainerView.snp.makeConstraints { loginContainerView in
            
            loginContainerView.top.equalTo(view.snp.topMargin).offset(Metrics.padding)
            loginContainerView.leading.trailing.equalToSuperview()
            loginContainerView.bottom.equalToSuperview().offset(Metrics.doublePadding)
        }
        
        cardContainerView.backgroundColor = .white
        cardContainerView.layer.cornerRadius = 30.0
        cardContainerView.clipsToBounds = true
    }
}
