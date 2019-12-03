//
//  ReservationsData.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

struct ReservationData: Codable {
    let id: String
    let timeStamp: Double
    let clientName: String?
    let numberOfPeople: Int?
    let iconImageURLString: String?
    let userId: String?
}
