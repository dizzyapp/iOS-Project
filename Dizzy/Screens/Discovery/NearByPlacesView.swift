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
    private let placesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PlacesListFlowLayout())
    
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
        self.placesViewContainer.addSubviews([searchButton, titleLabel, placesCollectionView])
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
        
        placesCollectionView.snp.makeConstraints { placesCollectionView in
            placesCollectionView.top.equalTo(titleLabel).offset(2 * Metrics.doublePadding)
            placesCollectionView.leading.equalToSuperview().offset(Metrics.oneAndHalfPadding)
            placesCollectionView.trailing.equalToSuperview().offset(-Metrics.oneAndHalfPadding)
            placesCollectionView.bottom.equalToSuperview()
        }
    }
    
    private func setupViews() {
        addKeyboardListeners()
        setupSearchBar()
        setupPlacesViewContainer()
        setupSearchButton()
        setupTitleLabel()
        setupPlacesCollectionView()
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
    
    @objc private func didPressSearch() {
        searchDelegate?.didPressSearch()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Fonts.h6(weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor(hexString: "1900AF")
        titleLabel.text = "DISCOVER".localized
    }
    
    private func setupPlacesCollectionView() {
        placesCollectionView.allowsSelection = false
        placesCollectionView.dataSource = self
        placesCollectionView.backgroundColor = .clear
        placesCollectionView.contentInset = safeAreaInsets

        placesCollectionView.register(DiscoveryPlaceCell.self, forCellWithReuseIdentifier: cellIDentifier)
    }
    
    func reloadData() {
        placesCollectionView.collectionViewLayout.invalidateLayout()
        placesCollectionView.reloadData()
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(collectionViewContentInsets: UIEdgeInsets) {
        placesCollectionView.contentInset = collectionViewContentInsets
    }
    
    func set(keyboardDismissMode: UIScrollView.KeyboardDismissMode) {
        placesCollectionView.keyboardDismissMode = keyboardDismissMode
    }
    
    func showSearchMode() {
        searchButton.isHidden = true
        titleLabel.text = "SEARCH".localized
        searchBar.alpha = 1
        searchBar.startEditing()
        searchBarToPlacesViewConstraint?.activate()
        placesViewToSuperviewConstraint?.deactivate()
    }
    
    func hideSearchMode() {
        searchButton.isHidden = false
        searchBar.stopEditing()
        titleLabel.text = "DISCOVER".localized
        searchBar.alpha = 0
        searchBarToPlacesViewConstraint?.deactivate()
        placesViewToSuperviewConstraint?.activate()
    }
    
    private func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        self.placesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.placesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension NearByPlacesView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemsInSection = self.dataSource?.numberOfItemsForSection(section) ?? 0
        return itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDentifier, for: indexPath) as? DiscoveryPlaceCell,
            let placeInfo = self.dataSource?.itemForIndexPath(indexPath) else {
            print("could not dequeue \(cellIDentifier) or datasource is nil")
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setPlaceInfo(placeInfo, currentAppLocation: dataSource?.getCurrentLocation())
        return cell
    }
}

extension NearByPlacesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
}

extension NearByPlacesView: DiscoveryPlaceCellDelegate {
    func discoveryPlaceCellDidPressIcon(_ cell: DiscoveryPlaceCell) {
        guard let indexPath = placesCollectionView.indexPath(for: cell) else { return }
        delegate?.didPressPlaceIcon(atIndexPath: indexPath)
    }
    
    func discoveryPlaceCellDidPressDetails(_ cell: DiscoveryPlaceCell) {
        guard let indexPath = placesCollectionView.indexPath(for: cell) else { return }
        delegate?.didPressPlaceDetails(atIndexPath: indexPath)
    }
}

extension NearByPlacesView: SearchBarDelegate {
    func searchTextChanged(newText: String) {
        searchDelegate?.searchTextChanged(newText: newText)
        placesCollectionView.setContentOffset(.zero, animated: true)
    }
    
    func closePressed() {
        searchDelegate?.endSearch()
    }
}
