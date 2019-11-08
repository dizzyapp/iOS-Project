//
//  DizzyUser.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

enum UserRole: String, Codable {
    
    init(from decoder: Decoder) throws {
        let roleText = try decoder.singleValueContainer().decode(String.self)
        switch roleText {
        case "customer":
            self = .customer
        default:
            self = .guest
        }
    }
    
    case customer
    case guest
}

struct DizzyUser: Codable {
    let id: String
    let fullName: String
    let email: String
    let role: UserRole
    let photoURL: URL?
    
    static func guestUser() -> DizzyUser {
        return DizzyUser(id: "", fullName: "", email: "", role: .guest, photoURL: nil)
    }
}
