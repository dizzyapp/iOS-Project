//
//  WebResource.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

struct Resource<Response: Codable, Body: Encodable> {
    var baseUrl: URL?
    var path: String
}
