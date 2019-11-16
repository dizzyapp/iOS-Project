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
    let nearByPlacesView = NearByPlacesView()
    var viewModel: DiscoveryVMType
    let appStartVM: AppStartVMType
    
    let nearByPlacesViewPadding = CGFloat(0)
    let nearByPlacesViewHeightRatio = CGFloat(0.50)
    
    private var nearByPlacesTopConstraint: Constraint?
    
    var isItFirstPageLoad = true
    
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
        self.view.addSubviews([themeVideoView, topBar, nearByPlacesView])
    }
    
    private func layoutViews() {
        
        topBar.snp.makeConstraints { topBar in
            topBar.top.equalTo(view.snp.topMargin)
            topBar.trailing.leading.equalToSuperview()
        }
        
        themeVideoView.snp.makeConstraints { themeImageView in
            
            themeImageView.top.leading.bottom.trailing.equalToSuperview()
        }
        
        nearByPlacesView.snp.makeConstraints { nearByPlacesView in
            
            nearByPlacesTopConstraint = nearByPlacesView.top.equalTo(themeVideoView.snp.bottom).constraint
            nearByPlacesView.leading.equalToSuperview().offset(nearByPlacesViewPadding)
            nearByPlacesView.trailing.equalToSuperview().offset(-nearByPlacesViewPadding)
            nearByPlacesView.bottom.equalToSuperview()
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
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        addSwipeDelegate()
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
    
    private func setupNearByPlacesView() {
        nearByPlacesView.dataSource = self
        nearByPlacesView.delegate = self
        nearByPlacesView.searchDelegate = self
        nearByPlacesView.alpha = 0.9
        nearByPlacesView.reloadData()
    }
    
    private func showPlacesOnHalfScreenWithAnimation() {
        UIView.animate(withDuration: 1) {
            self.showPlacesOnHalfScreen()
            self.view.layoutIfNeeded()
        }
    }

    private func showPlacesOnHalfScreen() {
        self.nearByPlacesTopConstraint?.update(offset: -self.view.frame.height/2 - 25)
    }
    
    private func showPlacesOnFullScreen() {
        self.nearByPlacesTopConstraint?.update(offset: -self.view.frame.height)
    }
    
    private func hidelacesWithAnimation(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nearByPlacesTopConstraint?.update(offset: 0)
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
        if viewModel.isSearching {
            self.endSearch()
        } else {
            hidelacesWithAnimation {
                self.mapButtonPressed()
            }
        }
    }
    
    @objc func onSwipeUp() {
        guard !viewModel.isSearching else { return }
        didPressSearch()
    }
}

extension DiscoveryVC: NearByPlacesViewDataSource {
    func getCurrentLocation() -> Location? {
        return viewModel.currentLocation.value
    }
    
    func numberOfSections() -> Int {
        return viewModel.numberOfSections()
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return viewModel.numberOfItemsForSection(section)
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return viewModel.itemForIndexPath(indexPath)
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
        showDizzyPopup(withMessage: "Are you in \(place.name)?", imageUrl: place.imageURLString, onOk: { [weak self] in
            self?.viewModel.userApprovedHeIsIn(place: place)
            }, onCancel: { [weak self] in
               self?.viewModel.userDeclinedHeIsInPlace()
        })
    }
    
    func reloadData() {
        nearByPlacesView.reloadData()
    }
    
    func allPlacesArrived() {
        nearByPlacesView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            guard self.appStartVM.appUserReturned else {
                self.allPlacesArrived()
                return
            }
            self.showPlacesOnHalfScreenWithAnimation()
            self.viewModel.checkClosestPlace()
        })
    }
}

extension DiscoveryVC: NearByPlacesViewDelegate {
    func didPressPlaceIcon(atIndexPath indexPath: IndexPath) {
        viewModel.placeCellIconPressed(atIndexPath: indexPath)
    }
    
    func didPressPlaceDetails(atIndexPath indexPath: IndexPath) {
        viewModel.placeCellDetailsPressed(atIndexPath: indexPath)
    }
}

extension DiscoveryVC: NearByPlacesViewSearchDelegate {
    func searchTextChanged(newText: String) {
        viewModel.searchPlacesByName(newText)
    }
    
    func didPressSearch() {
        viewModel.searchPlacePressed()
        UIView.animate(withDuration: 1) {
            self.topBar.alpha = 0
            self.nearByPlacesView.showSearchMode()
            self.showPlacesOnFullScreen()
            self.view.layoutIfNeeded()
        }
    }
    
    func endSearch() {
        viewModel.searchEnded()
        UIView.animate(withDuration: 1) {
            self.topBar.alpha = 1
            self.nearByPlacesView.hideSearchMode()
            self.showPlacesOnHalfScreen()
            self.viewModel.searchPlacesByName("")
            self.view.layoutIfNeeded()
        }
    }
}
