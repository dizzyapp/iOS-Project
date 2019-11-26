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
    var otherButtonOnFocuse: Observable<Bool> { get set }
    var placeName: String { get }
    var userName: String { get }
    
    func didFinish()
    func requestATable(with name: String?, numberOfPeople: String?, time: String?, comment: String?)
}

final class ReserveTableVM: ReserveTableVMType {
    
    var otherButtonOnFocuse = Observable<Bool>(false)
    var reserveTableFinished: () -> Void = { }
    var placeName: String
    var userName: String
    
    let placeInfo: PlaceInfo
    
    init(placeInfo: PlaceInfo, user: DizzyUser) {
        self.placeInfo = placeInfo
        placeName = placeInfo.name
        userName = user.fullName
    }
    
    func requestATable(with name: String?, numberOfPeople: String?, time: String?, comment: String?) {
        var messageText = "Hi, I want to reserve a table at \(placeInfo.name)"
        
        if let numberOfPeople = numberOfPeople, !numberOfPeople.isEmpty {
            messageText += " for \(numberOfPeople) people"
        }
        
        if let time = time, !time.isEmpty {
            messageText += " \(time)"
        }
        
        if let comment = comment, !comment.isEmpty {
            messageText += " \(comment)"
        }
        
        if let name = name, !name.isEmpty {
            messageText += "/n -[\(name)]"
        }
        
        requestATable(placeInfo, text: messageText)
        reserveTableFinished()
    }
    
    func didFinish() {
        reserveTableFinished()
    }
}
