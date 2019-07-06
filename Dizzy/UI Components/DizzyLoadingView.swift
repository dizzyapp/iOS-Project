//
//  DizzyLoadingView.swift
//  Dizzy
//
//  Created by Menashe, Or on 07/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

class DizzyLoadingView: UIView {
    let loadingIcon = UIImageView()
    
    init(backgroundColor: UIColor = .white) {
        super.init(frame: .zero)
        layoutView()
        setupLoadingIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        self.addSubview(loadingIcon)
        
        loadingIcon.snp.makeConstraints { logoIcon in
            logoIcon.top.greaterThanOrEqualTo(self.snp.top)
            logoIcon.leading.greaterThanOrEqualTo(self.snp.leading)
            logoIcon.trailing.lessThanOrEqualTo(self.snp.trailing)
            logoIcon.bottom.lessThanOrEqualTo(self.snp.bottom)
            logoIcon.center.equalToSuperview()
        }
    }
    
    func setupLoadingIcon() {
        loadingIcon.image = Images.loadingLogo()
        loadingIcon.contentMode = .center
    }
    
    func startLoadingAnimation() {
        changeLogoVisability()
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeLogoVisability), userInfo: nil, repeats: true)
    }
    
    func stopLoadingAnimation() {
        Timer.cancelPreviousPerformRequests(withTarget: stopLoadingAnimation)
    }
    
    @objc func changeLogoVisability() {
        UIView.animate(withDuration: 2.0) {
            self.loadingIcon.alpha = 1 - self.loadingIcon.alpha
            self.layoutIfNeeded()
        }
    }

}
