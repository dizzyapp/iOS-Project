//
//  PlaceSearchVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 22/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

final class PlaceSearchVC: ViewController {

    private var workItem: DispatchWorkItem?
    private let viewModel: PlaceSearchVMType
    private let placesViews = NearByPlacesView()
    private let searchTextField = UITextField(frame: .zero)
    private let closeButton = UIButton().navigaionCloseButton
    
    private let searchBarHeight: CGFloat = 30
    
    init(viewModel: PlaceSearchVMType) {
        self.viewModel = viewModel
        super.init()
        setupViews()
        addSubviews()
        layoutViews()
        viewModel.filter(filterString: "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view.addSubviews([placesViews, closeButton, searchTextField])
    }
    
    private func layoutViews() {
        placesViews.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Metrics.doublePadding)
            make.leading.equalToSuperview().offset(Metrics.tinyPadding)
            make.trailing.equalToSuperview().inset(Metrics.tinyPadding)
            make.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(Metrics.doublePadding)
            make.leading.equalToSuperview().offset(Metrics.doublePadding)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(closeButton)
            make.leading.equalTo(closeButton.snp.trailing).offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
            make.height.equalTo(searchBarHeight)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        modalPresentationStyle = .overCurrentContext

        setupPlacesView()
        setupSearchTextField()
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setupPlacesView() {
        placesViews.hideSearchButton()
        placesViews.set(title: "Search".localized)
        placesViews.set(keyboardDismissMode: .onDrag)
        placesViews.dataSource = self
        placesViews.reloadData()
    }
    
    private func setupSearchTextField() {
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
        searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        searchTextField.layer.cornerRadius = 10
        searchTextField.addPaddingToMarker()
        searchTextField.textColor = .white
        searchTextField.tintColor = .white
    }
    
    @objc private func close() {
        viewModel.closeButtonPressed()
    }
}

extension PlaceSearchVC: NearByPlacesViewDataSource {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return viewModel.itemAt(indexPath)
    }
    
    func getCurrentLocation() -> Location? {
        return viewModel.currentLocation.value
    }
}

extension PlaceSearchVC {
    @objc func searchTextFieldDidChange() {
        self.workItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.filter(filterString: self.searchTextField.text ?? "")
            self.placesViews.reloadData()
        }
        
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: workItem)
    }
}
