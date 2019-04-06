//
//  WebService.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

protocol WebServiceType {
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void)
}
