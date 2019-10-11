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

class DiscoveryVC: ViewController {
    
    let topBar = DiscoveryTopBar()
    let themeVideoView = VideoView()
    let nearByPlacesView = NearByPlacesView()
    var viewModel: DiscoveryVMType
    
    let nearByPlacesViewPadding = CGFloat(5)
    let nearByPlacesViewHeightRatio = CGFloat(0.50)
    
    private var themeImageHeightConstraint: Constraint?
    private var nearByPlacesTopConstraint: Constraint?
    
    var isItFirstPageLoad = true
    
    init(viewModel: DiscoveryVMType) {
        self.viewModel = viewModel
        super.init()
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
    
    private func addSubviews() {
        self.view.addSubviews([themeVideoView, topBar, nearByPlacesView])
    }
    
    private func layoutViews() {
        
        topBar.snp.makeConstraints { topBar in
            topBar.top.equalTo(view.snp.topMargin)
            topBar.trailing.leading.equalToSuperview()
        }
        
        themeVideoView.snp.makeConstraints { themeImageView in
            
            themeImageView.top.leading.trailing.equalToSuperview()
            themeImageHeightConstraint = themeImageView.height.equalTo(view.snp.height).constraint
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
                self?.topBar.setLocationName("getting location")
                return
            }
            self?.topBar.setLocationName(currentCity)
        })
        
        viewModel.currentLocation.bind { _ in
            self.reloadData()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        setupNearByPlacesView()
        setupTopBarView()
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
        nearByPlacesView.alpha = 0.9
        nearByPlacesView.reloadData()
    }
    
    private func showNewrByPlacesWithAnimation() {
        UIView.animate(withDuration: 1) {
            self.nearByPlacesTopConstraint?.update(offset: -25)
            self.themeImageHeightConstraint?.update(offset: -self.view.frame.height / 2)
            self.view.layoutIfNeeded()
        }
    }
    
    public func showTopBar() {
        self.topBar.isHidden = false
    }
    
    public func hideTopBar() {
        self.topBar.isHidden = true
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
    func mapButtonPressed() {
        viewModel.mapButtonPressed()
    }
    
    func menuButtonPressed() {
        self.viewModel.menuButtonPressed()
    }
}

extension DiscoveryVC: DiscoveryVMDelegate {
    func reloadData() {
        nearByPlacesView.reloadData()
    }
    
    func allPlacesArrived() {
        nearByPlacesView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.showNewrByPlacesWithAnimation()
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
