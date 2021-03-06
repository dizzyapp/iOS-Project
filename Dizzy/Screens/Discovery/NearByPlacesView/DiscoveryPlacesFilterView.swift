//
//  DiscoveryPlacesFilterView.swift
//  Dizzy
//
//  Created by Menashe, Or on 03/02/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

protocol DiscoveryPlacesFilterViewDelegate: class {
    func filterButtonPressed(selectedText: String)
    func showAllPlaces()
}

class DiscoveryPlacesFilterView: UIView {
    
    let scrollView = UIScrollView()
    let filterItemsStackView = UIStackView()
    let allButton = UIButton(type: .system)
    var selectedButton: UIButton
    weak var delegate: DiscoveryPlacesFilterViewDelegate?
    
    init() {
        selectedButton = allButton
        super.init(frame: CGRect.zero)
        layoutViews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setFilterItems(_ filterItems: [PlacesFilterTag]) {
        filterItemsStackView.removeAllSubviews()
        filterItemsStackView.addArrangedSubview(allButton)
        for item in filterItems {
            addItemToStackView(item: item)
        }
    }
    
    private func layoutViews() {
        layoutScrollView()
        layoutStackView()
    }
    
    private func layoutScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { scrollView in
            scrollView.edges.equalToSuperview()
        }
    }
    
    private func layoutStackView() {
        scrollView.addSubview(filterItemsStackView)
        filterItemsStackView.snp.makeConstraints { stackView in
            stackView.edges.equalToSuperview()
            stackView.centerY.equalToSuperview()
        }
    }
    
    private func setupViews() {
        setupScrollView()
        setupStackView()
        setupAllButton()
    }
    
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupStackView() {
        filterItemsStackView.axis = .horizontal
        filterItemsStackView.spacing = Metrics.mediumPadding
    }
    
    private func setupAllButton() {
        allButton.setTitle("All", for: .normal)
        allButton.addTarget(self, action: #selector(allButtonSelected), for: .touchUpInside)
        setButtonSelected(allButton)
        filterItemsStackView.addArrangedSubview(allButton)
    }
    
    private func addItemToStackView(item: PlacesFilterTag) {
        let button = UIButton(type: .system)
        button.setTitle(item.tagText, for: .normal)
        button.addTarget(self, action: #selector(filterItemSelected), for: .touchUpInside)
        setButtonUnselected(button)
        filterItemsStackView.addArrangedSubview(button)
    }
    
    @objc private func filterItemSelected(_ button: UIButton) {
        guard let filterText = button.titleLabel?.text else { return }
        setButtonSelected(button)
        delegate?.filterButtonPressed(selectedText: filterText)
    }
    
    @objc private func allButtonSelected() {
        setButtonSelected(allButton)
        delegate?.showAllPlaces()
    }
    
    private func setButtonUnselected(_ button: UIButton) {
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = Fonts.h6(weight: .medium)
        button.backgroundColor = UIColor.white
        button.setBorder(borderColor: UIColor.lightGray.withAlphaComponent(0.4), cornerRadius: 17)
        button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 10)
    }
    
    private func setButtonSelected(_ selectedButton: UIButton) {
        setButtonUnselected(self.selectedButton)
        self.selectedButton = selectedButton
        
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.titleLabel?.font = Fonts.h6(weight: .medium)
        selectedButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        selectedButton.setBorder(borderColor: .clear, cornerRadius: 17)
        selectedButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 10)
    }
}
