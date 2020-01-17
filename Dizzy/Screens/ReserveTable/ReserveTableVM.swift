//
//  ReserveTableVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol ReserveTableVMType: PlaceReservationRequestor {
    var reserveTableFinished: () -> Void { get set }
    var selectedTime: Observable<ReserveTableVC.ReservationTime?> { get set }
    var placeName: String { get }
    var userName: String { get }
    
    func didFinish()
    func requestATable(with name: String?, numberOfPeople: String?, comment: String?)
}

final class ReserveTableVM: ReserveTableVMType {
    
    var selectedTime = Observable<ReserveTableVC.ReservationTime?>(nil)
    var reserveTableFinished: () -> Void = { }
    let user: DizzyUser
    let placeInfo: PlaceInfo
    private let placesInteractor: PlacesInteractorType
    
    var placeName: String {
        return placeInfo.name
    }
    
    var userName: String {
        return user.fullName
    }
    
    init(placeInfo: PlaceInfo, user: DizzyUser, placesInteractor: PlacesInteractorType) {
        self.placeInfo = placeInfo
        self.user = user
        self.placesInteractor = placesInteractor
    }
    
    func requestATable(with name: String?, numberOfPeople: String?, comment: String?) {
        var messageText = "Hi, I want to reserve a table at \(placeInfo.name)"
        
        if let numberOfPeople = numberOfPeople, !numberOfPeople.isEmpty {
            messageText += " for \(numberOfPeople) people"
        }
        
        if let selectedTime = selectedTime.value,
            selectedTime != .other {
            messageText += " \(selectedTime.title)"
        }
        
        if selectedTime.value == .other,
            let comment = comment,
            !comment.isEmpty {
            messageText += " \(comment)"
        }
        
        if let name = name, !name.isEmpty {
            messageText += "\n -\(name)"
        }
        
        requestATable(placeInfo, text: messageText)
        
        let reservationData = ReservationData(id: user.id + UUID().uuidString,
                                              timeStamp: Date().timeIntervalSince1970 ,
                                              clientName: name,
                                              numberOfPeople: Int(numberOfPeople ?? ""),
                                              iconImageURLString: user.photoURL?.absoluteString ?? "",
                                              userId: user.id)
        
        sendReservationRecord(reservationData: reservationData)
        reserveTableFinished()
    }
    
    func didFinish() {
        reserveTableFinished()
    }
    
    private func sendReservationRecord(reservationData: ReservationData) {
        placesInteractor.setReservation(to: placeInfo.id, with: reservationData)
    }
}
