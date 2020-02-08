//
//  NearByPlacesView.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit

protocol NearByPlacesViewDataSource: class {
    func numberOfSections() -> Int
    func numberOfItemsForSection(_ section: Int) -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo
    func getCurrentLocation() -> Location?
}

protocol NearByPlacesViewSearchDelegate: class {
    func searchTextChanged(newText: String)
    func filterTagChanged(newTag: String)
    func didPressSearch()
    func endSearch()
}

protocol NearByPlacesViewDelegate: class {
    func didPressPlaceIcon(atIndexPath indexPath: IndexPath)
    func didPressPlaceDetails(atIndexPath indexPath: IndexPath)
}

class NearByPlacesView: UIView, LoadingContainer {
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    weak var delegate: NearByPlacesViewDelegate?
    weak var dataSource: NearByPlacesViewDataSource?
    weak var searchDelegate: NearByPlacesViewSearchDelegate?
    
    private let searchBar = SearchBar()
    private let placesViewContainer = UIView()
    private let searchButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let placesTableView = UITableView(frame: CGRect.zero)
    private let filterBar = DiscoveryPlacesFilterView()
    
    private var searchBarToPlacesViewConstraint: Constraint?
    private var placesViewToSuperviewConstraint: Constraint?
    
    private let cellIDentifier = "DiscoveryPlaceCell"
    
    let cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .white
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([searchBar, placesViewContainer])
        self.placesViewContainer.addSubviews([searchButton, titleLabel, placesTableView, filterBar])
    }
    
    private func layoutViews() {
        
        searchBar.snp.makeConstraints { searchBar in
            searchBar.top.equalToSuperview().offset(Metrics.doublePadding)
            searchBar.leading.equalToSuperview().offset(Metrics.doublePadding)
            searchBar.trailing.equalToSuperview().offset(-Metrics.doublePadding)
            searchBarToPlacesViewConstraint =  searchBar.bottom.equalTo(placesViewContainer.snp.top).offset(-Metrics.padding).priority(.high).constraint
        }
        searchBarToPlacesViewConstraint?.deactivate()
        
        placesViewContainer.snp.makeConstraints { placesViewContainer in
            placesViewContainer.leading.bottom.trailing.equalToSuperview()
            placesViewToSuperviewConstraint = placesViewContainer.top.equalToSuperview().constraint
        }
        
        searchButton.snp.makeConstraints { searchButton in
            searchButton.trailing.equalToSuperview().offset(-Metrics.doublePadding)
            searchButton.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { titleLabel in
            titleLabel.top.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            titleLabel.centerX.equalToSuperview()
            titleLabel.trailing.lessThanOrEqualTo(searchButton).offset(-Metrics.padding)
            titleLabel.leading.greaterThanOrEqualToSuperview().offset(Metrics.padding)
        }
        
        filterBar.snp.makeConstraints { filterBar in
            filterBar.leading.equalToSuperview().offset(Metrics.doublePadding)
            filterBar.trailing.equalToSuperview().inset(Metrics.doublePadding)
            filterBar.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
        }
        
        placesTableView.snp.makeConstraints { placesCollectionView in
            placesCollectionView.top.equalTo(filterBar.snp.bottom).offset(Metrics.doublePadding)
            placesCollectionView.leading.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            placesCollectionView.trailing.equalToSuperview().offset(-Metrics.oneAndHalfPadding)
            placesCollectionView.bottom.equalToSuperview().inset(Metrics.oneAndHalfPadding)
        }
    }
    
    private func setupViews() {
        addKeyboardListeners()
        setupSearchBar()
        setupPlacesViewContainer()
        setupSearchButton()
        setupTitleLabel()
        setupFilterBar()
        setupPlacesTableView()
    }
    
    private func setupSearchBar() {
        searchBar.alpha = 0
        searchBar.delegate = self
    }
    
    private func setupPlacesViewContainer() {
        placesViewContainer.layer.cornerRadius = cornerRadius
        placesViewContainer.backgroundColor = .white
    }
    
    private func setupSearchButton() {
        searchButton.setImage(Images.discoverySearchIcon(), for: .normal)
        searchButton.addTarget(self, action: #selector(didPressSearch), for: .touchUpInside)
    }
    
    private func setupFilterBar() {
        filterBar.delegate = self
    }
    
    @objc private func didPressSearch() {
        searchDelegate?.didPressSearch()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.h2(weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.dizzyBlue
        titleLabel.text = "Explore Nightlife".localized
    }
    
    private func setupPlacesTableView() {
        placesTableView.allowsSelection = false
        placesTableView.dataSource = self
        placesTableView.backgroundColor = .clear
        placesTableView.contentInset = safeAreaInsets
        placesTableView.register(DiscoveryPlaceCell.self, forCellReuseIdentifier: cellIDentifier)
    }
    
    func reloadData() {
        placesTableView.reloadData()
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(collectionViewContentInsets: UIEdgeInsets) {
        placesTableView.contentInset = collectionViewContentInsets
    }
    
    func set(keyboardDismissMode: UIScrollView.KeyboardDismissMode) {
        placesTableView.keyboardDismissMode = keyboardDismissMode
    }
    
    func showSearchMode() {
        searchButton.isHidden = true
        titleLabel.text = "Search Nightlife".localized
        searchBar.alpha = 1
        searchBar.startEditing()
        searchBarToPlacesViewConstraint?.activate()
        placesViewToSuperviewConstraint?.deactivate()
    }
    
    func hideSearchMode() {
        searchButton.isHidden = false
        searchBar.stopEditing()
        titleLabel.text = "Explore Nightlife".localized
        searchBar.alpha = 0
        searchBarToPlacesViewConstraint?.deactivate()
        placesViewToSuperviewConstraint?.activate()
    }
    
    func setFilterItems(_ filterItems: [String]) {
        filterBar.setFilterItems(filterItems)
    }
    
    private func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.placesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.placesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension NearByPlacesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIDentifier, for: indexPath) as? DiscoveryPlaceCell,
            let placeInfo = self.dataSource?.itemForIndexPath(indexPath) else {
                print("could not dequeue \(cellIDentifier) or datasource is nil")
                return UITableViewCell()
        }
        
        cell.delegate = self
        cell.setPlaceInfo(placeInfo, currentAppLocation: dataSource?.getCurrentLocation())
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let itemsInSection = self.dataSource?.numberOfItemsForSection(section) ?? 0
        return itemsInSection
    }
}

extension NearByPlacesView: DiscoveryPlaceCellDelegate {
    func discoveryPlaceCellDidPressIcon(_ cell: DiscoveryPlaceCell) {
        guard let indexPath = placesTableView.indexPath(for: cell) else { return }
        delegate?.didPressPlaceIcon(atIndexPath: indexPath)
    }
    
    func discoveryPlaceCellDidPressDetails(_ cell: DiscoveryPlaceCell) {
        guard let indexPath = placesTableView.indexPath(for: cell) else { return }
        delegate?.didPressPlaceDetails(atIndexPath: indexPath)
    }
}

extension NearByPlacesView: SearchBarDelegate {
    func searchTextChanged(newText: String) {
        searchDelegate?.searchTextChanged(newText: newText)
        placesTableView.setContentOffset(.zero, animated: true)
    }
    
    func closePressed() {
        searchDelegate?.endSearch()
    }
}

extension NearByPlacesView: DiscoveryPlacesFilterViewDelegate {
    func filterButtonPressed(selectedText: String) {
        searchDelegate?.filterTagChanged(newTag: selectedText)
    }
    
    func showAllPlaces() {
        searchDelegate?.filterTagChanged(newTag: "")
    }
}
