//
//  ProfileRequest.swift
//  Dizzy
//
//  Created by stas berkman on 19/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import FacebookCore
import FacebookLogin
struct profileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, photoURL"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
