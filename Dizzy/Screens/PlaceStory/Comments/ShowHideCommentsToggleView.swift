//
//  ShowHideCommentsToggleView.swift
//  Dizzy
//
//  Created by stas berkman on 04/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

enum ToggleState {
    case show
    case hide
}

class ShowHideCommentsToggleView: UIControl {

    private let stackView = UIStackView()
    private let hideCommentsImageView = UIImageView()
    private let showCommentsImageView = UIImageView()
    private let showHideCommentsLabel = UILabel()
    
    var toggleState: ToggleState = .show {
        didSet {
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(showCommentsImageView)
        stackView.addArrangedSubview(showHideCommentsLabel)
        stackView.addArrangedSubview(hideCommentsImageView)
        
        addSubview(stackView)
    }
    
    private func layoutViews() {
        layoutStackView()
    }
    
    private func layoutStackView() {
        stackView.snp.makeConstraints { stackView in
            stackView.edges.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupStackView()
        setupShowCommentsImageView()
        setupShowHideCommentsLabel()
        setupHideCommentsImageView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false
    }
    
    private func setupShowCommentsImageView() {
        showCommentsImageView.image = Images.showIcon()
        showCommentsImageView.isHidden = self.toggleState == .hide
    }
    
    private func setupShowHideCommentsLabel() {
        showHideCommentsLabel.text = self.toggleState == .show ? "Show comments".localized : "Hide comments".localized
        showHideCommentsLabel.textColor = .white
    }
    
    private func setupHideCommentsImageView() {
        hideCommentsImageView.image = Images.hideIcon()
        hideCommentsImageView.isHidden = self.toggleState == .show
    }
    
    func toggleShowHide() {
        self.toggleState = self.toggleState == .show ? .hide : .show
    }
}
