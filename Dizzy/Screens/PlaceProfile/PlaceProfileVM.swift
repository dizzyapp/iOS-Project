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
    var mediaViewToShow: Observable<UIView?> { get }
    var showNextArrow: Observable<Bool> { get }
    
    func closePressed()
    func addressButtonPressed(view: PlaceProfileView)
    func callButtonPressed()
    func requestTableButtonPressed()
    func storyButtonPressed()
    func placeImagePressed()
    func getTaxiButtonPressed(view: PlaceProfileView)
    func sholdShowStoryButton() -> Bool
    func onSwipeLeft()
    func onSwipeRight()
    func getPlaceEvent() -> String?
}

protocol PlaceProfileVMDelegate: class {
    func placeProfileVMClosePressed(_ viewModel: PlaceProfileVMType)
    func placeProfileVMUploadStoryButtonPressed(_ viewModel: PlaceProfileVMType)
    func placeProfileVMRequestATableTapped(_ viewModel: PlaceProfileVMType, with place: PlaceInfo)
    func placeProfileVMPlaceImagePresset(placeInfo: PlaceInfo)
    func placeProfileMenuButtonPressed(_ viewModel: PlaceProfileVMType, with place: PlaceInfo)
}

final class PlaceProfileVM: PlaceProfileVMType, PlaceReservationRequestor {
    
    var showNextArrow = Observable<Bool>(true)
    var mediaToShow: PlaceMedia?
    var mediaViewToShow = Observable<UIView?>(nil)
    var placeInfo: PlaceInfo
    let activePlace: PlaceInfo?
    let placesInteractor: PlacesInteractorType
    var profileMedia = [PlaceMedia]()
    weak var delegate: PlaceProfileVMDelegate?
    
    var externalNavigationProvider = ExternalNavigationProvider()
    
    var asyncMediaLoader = AsyncMediaLoader()
    
    init(placeInfo: PlaceInfo, activePlace: ActivePlace, placesInteractor: PlacesInteractorType) {
        self.placeInfo = placeInfo
        self.activePlace = activePlace.activePlaceInfo
        self.placesInteractor = placesInteractor
        self.asyncMediaLoader.showVideosInLoop = true
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
            self?.showNextArrow.value = profileMedia.count > 1
            self?.sortProfileMedia(profileMedia: profileMedia)
            self?.asyncMediaLoader.setMediaArray(profileMedia)
            self?.setMediaToShow(mediaToShow: self?.profileMedia[0])
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

        self.externalNavigationProvider.open(link: .waze(location: location))
    }
    
    func getTaxiButtonPressed(view: PlaceProfileView) {
        guard let location = view.placeInfo?.location else {
            return
        }
        placesInteractor.increment(analyticsType: .gettClicks, by: 1, to: placeInfo)
        self.externalNavigationProvider.open(link: .getTaxi(location: location))
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
        delegate?.placeProfileVMRequestATableTapped(self, with: placeInfo)
    }
    
    func closePressed() {
        delegate?.placeProfileVMClosePressed(self)
    }

    func storyButtonPressed() {
        delegate?.placeProfileVMUploadStoryButtonPressed(self)
    }
    
    func placeImagePressed() {
        delegate?.placeProfileVMPlaceImagePresset(placeInfo: placeInfo)
    }
    
    func sholdShowStoryButton() -> Bool {
        return placeInfo.id == activePlace?.id
    }
    
    func onSwipeLeft() {
        guard let displayingMediaIndex = getDisplayingMediaIndex(),
        displayingMediaIndex < profileMedia.count - 1 else {
            setMediaToShow(mediaToShow: profileMedia.first)
            return
        }
        
        setMediaToShow(mediaToShow: profileMedia[displayingMediaIndex + 1])
    }
    
    func onSwipeRight() {
        guard let displayingMediaIndex = getDisplayingMediaIndex(),
            displayingMediaIndex > 0 else {
                setMediaToShow(mediaToShow: profileMedia.last)
                return
        }
        
        setMediaToShow(mediaToShow: profileMedia[displayingMediaIndex - 1])
    }
    
    func getDisplayingMediaIndex() -> Int? {
        guard let index = profileMedia.firstIndex(where: { placeMedia -> Bool in
            return placeMedia.downloadLink == self.mediaToShow?.downloadLink
        }) else {
            return nil
        }
        
        return index
    }
    
    func getPlaceEvent() -> String? {
        return placeInfo.event
    }
    
    private func setMediaToShow(mediaToShow: PlaceMedia?) {
        self.mediaToShow = mediaToShow
        mediaViewToShow.value = asyncMediaLoader.getView(forPlaceMedia: mediaToShow)
    }
}
