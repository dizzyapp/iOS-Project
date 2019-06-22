//
//  SignUpDetails.swift
//  Dizzy
//
//  Created by Menashe, Or on 09/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

struct SignUpDetails: Codable {
    let fullName: String
    let email: String
    let password: String
    let repeatPassword: String
}
