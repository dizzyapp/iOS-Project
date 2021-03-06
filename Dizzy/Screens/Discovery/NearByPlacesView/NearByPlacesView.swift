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
    func itemForIndexPath(_ indexPath: IndexPath) -> NearByDataType
    func getCurrentLocation() -> Location?
    func title(for section: Int) -> String
}

protocol NearByPlacesViewSearchDelegate: class {
    func searchTextChanged(newText: String)
    func filterTagChanged(newTag: String)
    func didPressSearch()
    func endSearch()
}

protocol NearByPlacesViewDelegate: class {
    func didPressPlaceIcon(withPlaceId placeId: String)
    func didPressPlaceDetails(withPlaceId placeId: String)
    func didPressReserveATable(withPlaceID placeID: String)
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
    private let placesTableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let filterBar = DiscoveryPlacesFilterView()
    
    private var searchBarToPlacesViewConstraint: Constraint?
    private var placesViewToSuperviewConstraint: Constraint?
    
    private let cellIDentifier = "DiscoveryPlaceCell"
    
    let cornerRadius: CGFloat = 10.0
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
            titleLabel.top.equalToSuperview().offset(Metrics.doublePadding)
            titleLabel.leading.greaterThanOrEqualToSuperview().offset(Metrics.oneAndHalfPadding)
        }
        
        filterBar.snp.makeConstraints { filterBar in
            filterBar.leading.equalToSuperview().offset(Metrics.padding)
            filterBar.trailing.equalToSuperview()
            filterBar.top.equalTo(titleLabel.snp.bottom).offset(Metrics.doublePadding)
        }
        
        placesTableView.snp.makeConstraints { placesCollectionView in
            placesCollectionView.top.equalTo(filterBar.snp.bottom).offset(Metrics.padding)
            placesCollectionView.leading.equalToSuperview()
            placesCollectionView.trailing.equalToSuperview()
            placesCollectionView.bottom.equalToSuperview()
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
        placesViewContainer.backgroundColor = UIColor.white.withAlphaComponent(1)
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
        titleLabel.font = Fonts.i1(weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.black
        titleLabel.text = "Explore nightlife".localized
    }
    
    private func setupPlacesTableView() {
        placesTableView.allowsSelection = false
        placesTableView.dataSource = self
        placesTableView.delegate = self
        placesTableView.backgroundColor = .white
        placesTableView.contentInset = safeAreaInsets
        placesTableView.separatorStyle = .none
        placesTableView.register(DiscoveryPlaceCell.self, forCellReuseIdentifier: cellIDentifier)
        placesTableView.register(TodayEventCell.self, forCellReuseIdentifier: TodayEventCell.defaultReuseIdentifier)
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
        titleLabel.text = "Search nightlife".localized
        searchBar.alpha = 1
        searchBar.startEditing()
        searchBarToPlacesViewConstraint?.activate()
        placesViewToSuperviewConstraint?.deactivate()
    }
    
    func hideSearchMode() {
        searchButton.isHidden = false
        searchBar.stopEditing()
        titleLabel.text = "Explore nightlife".localized
        searchBar.alpha = 0
        searchBarToPlacesViewConstraint?.deactivate()
        placesViewToSuperviewConstraint?.activate()
    }
    
    func setFilterItems(_ filterItems: [PlacesFilterTag]) {
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

extension NearByPlacesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dataType = self.dataSource?.itemForIndexPath(indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: dataType.cellIdetifier, for: indexPath) as? DiscoveryCell
             else {
                return UITableViewCell()
        }
        
        cell.configure(with: dataType)
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let itemsInSection = self.dataSource?.numberOfItemsForSection(section) ?? 0
        return itemsInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = Fonts.i1(weight: .bold)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.text = self.dataSource?.title(for: section)
        return label
    }
}

extension NearByPlacesView: DiscoveryPlaceCellDelegate {
    func discoveryPlaceCellDidPressReserveATable(withPlaceID placeID: String) {
        delegate?.didPressReserveATable(withPlaceID: placeID)
    }
    
    func discoveryPlaceCellDidPressDetails(withPlaceId placeId: String) {
        delegate?.didPressPlaceDetails(withPlaceId: placeId)
    }
    
    func discoveryPlaceCellDidPressIcon(withPlaceId placeId: String) {
        delegate?.didPressPlaceIcon(withPlaceId: placeId)
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
