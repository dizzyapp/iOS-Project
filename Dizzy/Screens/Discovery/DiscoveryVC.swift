//
//  DiscoveryVC.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import SnapKit
import AVKit
import AVFoundation

class DiscoveryVC: ViewController, PopupPresenter {
    
    let topBar = DiscoveryTopBar()
    let themeVideoView = VideoView()
    let horizontalPlacesView = HorizontalPlacesView()
    let nearByPlacesView = NearByPlacesView()
    var viewModel: DiscoveryVMType
    let appStartVM: AppStartVMType
    
    let nearByPlacesViewPadding = CGFloat(10)
    let nearByPlacesViewHeightRatio = CGFloat(0.50)
    
    private var nearByPlacesTopConstraint: Constraint?
    
    var isItFirstPageLoad = true
    var isShowingPopup = false
    
    init(viewModel: DiscoveryVMType, appStartVM: AppStartVMType) {
        self.viewModel = viewModel
        self.appStartVM = appStartVM
        super.init()
        appStartVM.getLoggedInUser()
        addSubviews()
        layoutViews()
        setupViews()
        bindViewModel()
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isItFirstPageLoad {
            setupThemeVideoView()
            themeVideoView.play()
            isItFirstPageLoad = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        endSearch()
    }
    
    private func addSubviews() {
        self.view.addSubviews([themeVideoView, topBar,horizontalPlacesView, nearByPlacesView])
    }
    
    private func layoutViews() {
        
        topBar.snp.makeConstraints { topBar in
            topBar.top.equalTo(view.snp.topMargin)
            topBar.trailing.leading.equalToSuperview()
        }
        
        themeVideoView.snp.makeConstraints { themeImageView in
            
            themeImageView.top.leading.bottom.trailing.equalToSuperview()
        }
        
        horizontalPlacesView.snp.makeConstraints { horizontalPlacesView in
            horizontalPlacesView.bottom.equalTo(nearByPlacesView.snp.top).offset(-Metrics.padding)
            horizontalPlacesView.leading.equalTo(nearByPlacesView.snp.leading)
            horizontalPlacesView.trailing.equalTo(nearByPlacesView.snp.trailing)
        }
        
        nearByPlacesView.snp.makeConstraints { nearByPlacesView in
            
            nearByPlacesTopConstraint = nearByPlacesView.top.equalTo(themeVideoView.snp.bottom).constraint
            nearByPlacesView.leading.equalToSuperview().offset(nearByPlacesViewPadding)
            nearByPlacesView.trailing.equalToSuperview().offset(-nearByPlacesViewPadding)
            nearByPlacesView.height.equalToSuperview().multipliedBy(0.69)
        }
    }
    
    private func bindViewModel() {
        viewModel.currentCity.bind(shouldObserveIntial: true, observer: { [weak self] currentCity in
            guard !currentCity.isEmpty else {
                self?.topBar.setLocationName("Getting location".localized)
                return
            }
            self?.topBar.setLocationName(currentCity)
        })
        
        viewModel.filterItems.bind(shouldObserveIntial: true) {[weak self] filterItems in
            self?.nearByPlacesView.setFilterItems(filterItems)
        }
        
        viewModel.sortedPlacesByStoriesTime.bind(shouldObserveIntial: true) {[weak self] _ in
            self?.horizontalPlacesView.reloadData()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        addSwipeDelegate()
        setupHorizontalPlacesView()
        setupNearByPlacesView()
        setupTopBarView()
    }
    
    private func addSwipeDelegate() {
        let downSwipe = UISwipeGestureRecognizer(target : self, action : #selector(onSwipeDown))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target : self, action : #selector(onSwipeUp))
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
    }
    
    private func setupTopBarView() {
        topBar.delegate = self
        topBar.hideButtons()
    }
    
    private func setupThemeVideoView() {
        guard let path = Bundle.main.path(forResource: "dizzySplash", ofType:"mp4") else {
                print("coult not find vieo url of discovery vc")
            return
        }
        let videoUrl = URL(fileURLWithPath: path)
        themeVideoView.configure(url: videoUrl)
        themeVideoView.play()
    }
    
    private func setupHorizontalPlacesView() {
        horizontalPlacesView.dataSource = self
        horizontalPlacesView.delegate = self
        hideHorizontalPlacesView()
    }
    
    private func setupNearByPlacesView() {
        nearByPlacesView.dataSource = self
        nearByPlacesView.delegate = self
        nearByPlacesView.searchDelegate = self
        nearByPlacesView.alpha = 0.97
        nearByPlacesView.reloadData()
    }
    
    private func showPlacesOnHalfScreenWithAnimation() {
        UIView.animate(withDuration: 1) {
            self.showPlacesOnHalfScreen()
            self.showHorizontalPlacesView()
            self.view.layoutIfNeeded()
        }
    }
    
    private func showTopBarButtonsWithAnimation() {
        UIView.animate(withDuration: 1) {
            self.topBar.showButtons()
            self.view.layoutIfNeeded()
        }
    }

    private func showPlacesOnHalfScreen() {
        self.nearByPlacesTopConstraint?.update(offset: -self.view.frame.height/1.4)
    }
    
    private func showHorizontalPlacesView() {
        horizontalPlacesView.alpha = 1
    }
    
    private func hideHorizontalPlacesView() {
        horizontalPlacesView.alpha = 0
    }
    
    private func showNearByPlacesOnFullScreen() {
        self.nearByPlacesTopConstraint?.update(offset: -self.view.frame.height + view.safeAreaInsets.top + Metrics.padding)
    }
    
    private func hidePlacesWithAnimation(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nearByPlacesTopConstraint?.update(offset: 0)
            self.hideHorizontalPlacesView()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    public func showTopBar() {
        self.topBar.isHidden = false
    }
    
    public func hideTopBar() {
        self.topBar.isHidden = true
    }
    
    @objc func onSwipeDown() {
        guard viewModel.isSpalshEnded,
        !isShowingPopup else { return }
        
        if viewModel.isSearching {
            self.endSearch()
        } else {
            hidePlacesWithAnimation {
                self.mapButtonPressed()
            }
        }
    }
    
    @objc func onSwipeUp() {
        guard viewModel.isSpalshEnded,
            !viewModel.isSearching,
            !isShowingPopup else { return }
        didPressSearch()
    }
}

extension DiscoveryVC: NearByPlacesViewDataSource {
    func title(for section: Int) -> String {
        viewModel.title(for: section)
    }
    
    func getCurrentLocation() -> Location? {
        return viewModel.currentLocation.value
    }
    
    func numberOfSections() -> Int {
        return viewModel.numberOfSections(forListType: .nearByPlaces)
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return viewModel.numberOfItemsForSection(section, forListType: .nearByPlaces)
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> NearByDataType {
        viewModel.nearByItem(at: indexPath)
    }
}

extension DiscoveryVC: DiscoveryTopBarDelegate {
    func locationLablePressed() {
        viewModel.locationLablePressed()
    }
    
    func mapButtonPressed() {
        viewModel.mapButtonPressed()
    }
    
    func menuButtonPressed() {
        self.viewModel.menuButtonPressed()
    }
}

extension DiscoveryVC: DiscoveryVMDelegate {
    func askIfUserIsInThisPlace(_ place: PlaceInfo) {
        guard !isShowingPopup else {
            return
        }
        
        isShowingPopup = true
        showDizzyPopup(withMessage: "Are you at \(place.name)?", imageUrl: place.imageURLString, onOk: { [weak self] in
            self?.isShowingPopup = false
            self?.viewModel.userApprovedHeIsIn(place: place)
            }, onCancel: { [weak self] in
                self?.isShowingPopup = false
               self?.viewModel.userDeclinedHeIsInPlace()
        })
    }
    
    func reloadData() {
        nearByPlacesView.reloadData()
    }
    
    func allPlacesArrived() {
        nearByPlacesView.reloadData()
        horizontalPlacesView.reloadData()
    }
    
    func showContentWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            guard self.appStartVM.appUserReturned else {
                self.allPlacesArrived()
                return
            }
            self.showPlacesOnHalfScreenWithAnimation()
            self.showTopBarButtonsWithAnimation()
            self.viewModel.splashEnded()
            self.viewModel.checkClosestPlace()
        })
    }
}

extension DiscoveryVC: NearByPlacesViewDelegate {

    func didPressPlaceIcon(withPlaceId placeId: String) {
        viewModel.placeCellIconPressed(withId: placeId)
    }
    
    func didPressPlaceDetails(withPlaceId placeId: String) {
        viewModel.placeCellDetailsPressed(withId: placeId)
    }
}

extension DiscoveryVC: NearByPlacesViewSearchDelegate {
    func filterTagChanged(newTag: String) {
        viewModel.searchPlacesByNameAndDescription(nil, newTag)
    }
    
    func searchTextChanged(newText: String) {
        viewModel.searchPlacesByNameAndDescription(newText, nil)
    }
    
    func didPressSearch() {
        viewModel.searchPlacePressed()
        UIView.animate(withDuration: 0.3) {
            self.topBar.alpha = 0
            self.nearByPlacesView.showSearchMode()
            self.showNearByPlacesOnFullScreen()
            self.hideHorizontalPlacesView()
            self.view.layoutIfNeeded()
        }
    }
    
    func endSearch() {
        viewModel.searchEnded()
        UIView.animate(withDuration: 0.3) {
            self.topBar.alpha = 1
            self.nearByPlacesView.hideSearchMode()
            self.showPlacesOnHalfScreen()
            self.showHorizontalPlacesView()
            self.viewModel.searchPlacesByNameAndDescription("", nil)
            self.view.layoutIfNeeded()
        }
    }
}

extension DiscoveryVC: HorizontalPlacesViewDataSource, HorizontalPlacesViewDelegate {
    func placeSelected(withId placeId: String) {
        viewModel.placeCellIconPressed(withId: placeId)
    }
    
    func numberOfPlaces() -> Int {
        viewModel.numberOfItemsForSection(0, forListType: .sortedListByStories)
    }
    
    func placeInfoForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return viewModel.placeItem(at: indexPath)
    }
    
}
