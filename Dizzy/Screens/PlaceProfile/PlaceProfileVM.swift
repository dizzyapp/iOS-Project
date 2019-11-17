//
//  PlaceProfileVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol PlaceProfileVMType {
    var placeInfo: PlaceInfo { get }
    var delegate: PlaceProfileVMDelegate? { get set }
    var mediaToShow: Observable<PlaceMedia?> { get }
    
    func closePressed()
    func addressButtonPressed(view: PlaceProfileView)
    func callButtonPressed()
    func requestTableButtonPressed()
    func storyButtonPressed()
    func sholdShowStoryButton() -> Bool
    func onSwipeLeft()
    func onSwipeRight()
}

protocol PlaceProfileVMDelegate: class {
    func placeProfileVMClosePressed(_ viewModel: PlaceProfileVMType)
    func placeProfileVMStoryButtonPressed(_ viewModel: PlaceProfileVMType)
    func placeProfileVMRequestATableTapped(_ viewModel: PlaceProfileVMType, with place: PlaceInfo)
}

final class PlaceProfileVM: PlaceProfileVMType, PlaceReservationRequestor {
    var mediaToShow = Observable<PlaceMedia?>(nil)
    var placeInfo: PlaceInfo
    let activePlace: PlaceInfo?
    let placesInteractor: PlacesInteractorType
    var profileMedia = [PlaceMedia]()
    weak var delegate: PlaceProfileVMDelegate?
    
    var externalNavigationProvider = ExternalNavigationProvider()

    init(placeInfo: PlaceInfo, activePlace: ActivePlace, placesInteractor: PlacesInteractorType) {
        self.placeInfo = placeInfo
        self.activePlace = activePlace.activePlaceInfo
        self.placesInteractor = placesInteractor
        
        bindPlaces()
        sendProfileViewsAdminAnalytics()
        getProfileMedia()
    }
    
    private func bindPlaces() {
        placesInteractor.allPlaces.bind { [weak self] places in
            let updatedPlace = places.first { $0.id == self?.placeInfo.id }
            if let placeInfo = updatedPlace {
                self?.placeInfo = placeInfo
            }
        }
    }
    
    private func sendProfileViewsAdminAnalytics() {
        placesInteractor.increment(analyticsType: .profileViews, by: 1, to: placeInfo)
    }
    
    func getProfileMedia() {
        placesInteractor.getProfileMedia(forPlaceId: placeInfo.id) { [weak self] profileMedia in
            self?.sortProfileMedia(profileMedia: profileMedia)
            self?.mediaToShow.value = self?.profileMedia[0]
        }
    }
    
    func sortProfileMedia(profileMedia: [PlaceMedia]) {
        self.profileMedia = profileMedia.sorted(by: { (mediaA, mediaB) -> Bool in
            guard let timeStampA = mediaA.timeStamp,
                let timeStampB = mediaB.timeStamp else {
                    return mediaA.timeStamp != nil
            }
            return timeStampA < timeStampB
        })
    }
    
    func addressButtonPressed(view: PlaceProfileView) {
        guard let location = view.placeInfo?.location else {
            return
        }

        self.externalNavigationProvider.openWaze(location: location)
    }

    func callButtonPressed() {
        guard let phoneNumber = placeInfo.publicistPhoneNumber, !phoneNumber.isEmpty,
            let url = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func sendReserveClickAdminAnalytics() {
        placesInteractor.increment(analyticsType: .reserveClicks, by: 1, to: placeInfo)
    }
    
    func requestTableButtonPressed() {
        sendReserveClickAdminAnalytics()
        requestATable(placeInfo)
    }
    
    func closePressed() {
        delegate?.placeProfileVMClosePressed(self)
    }

    func storyButtonPressed() {
        delegate?.placeProfileVMStoryButtonPressed(self)
    }
    
    func sholdShowStoryButton() -> Bool {
        return placeInfo.id == activePlace?.id
    }
    
    func onSwipeLeft() {
        guard let displayingMediaIndex = getDisplayingMediaIndex(),
        displayingMediaIndex < profileMedia.count - 1 else {
            mediaToShow.value = profileMedia.first
            return
        }
        
        mediaToShow.value = profileMedia[displayingMediaIndex + 1]
        
    }
    
    func onSwipeRight() {
        guard let displayingMediaIndex = getDisplayingMediaIndex(),
            displayingMediaIndex > 0 else {
                mediaToShow.value = profileMedia.last
                return
        }
        
        mediaToShow.value = profileMedia[displayingMediaIndex - 1]
    }
    
    func getDisplayingMediaIndex() -> Int? {
        guard let index = profileMedia.firstIndex(where: { placeMedia -> Bool in
            return placeMedia.downloadLink == self.mediaToShow.value?.downloadLink
        }) else {
            return nil
        }
        
        return index
    }
}
