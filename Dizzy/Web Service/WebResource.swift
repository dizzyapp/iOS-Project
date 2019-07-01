//
//  WebResource.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import UIKit

enum HttpMethod<Body: Encodable> {
    
    case get
    case post(data: Body)
    case delete
    
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
}

struct Resource<Response: Codable, Body: Encodable> {
    var baseUrl: String = ""
    var path: String
    var method: HttpMethod<Body>?
    var presentedVC: UIViewController?
    
    init(path: String) {
        self.path = path
    }
    
    func withPost(_ body: Body) -> Resource<Response, Body> {
        var resource = self
        resource.method = HttpMethod<Body>.post(data: body)
        return resource
    }
    
    func withGet() -> Resource<Response, Body> {
        var resource = self
        resource.method = HttpMethod<Body>.get
        return resource
    }
    
    func withDelete() -> Resource<Response, Body> {
        var resource = self
        resource.method = HttpMethod<Body>.delete
        return resource
    }
    
    func withPresentedVC(_ presentedVC: UIViewController) -> Resource<Response, Body> {
        var resource = self
        resource.presentedVC = presentedVC
        return resource
    }
    
    func parse(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        
        let response: Response
        do {
            response = try decoder.decode(Response.self, from: data)
        } catch {
            if case DecodingError.keyNotFound(let key, let context) = error {
                debugPrint("[Resource] decoding failed. key not found: \(key), context: \(context)")
            } else {
                debugPrint("[Resource] decoding failed:\n\(error)")
            }
            
            throw error
        }
        
        return response
    }
    
    func makeJson() -> [String: Any]? {
        guard let method = method, case let .post(body) = method else { return nil }
        let jsonEncoder = JSONEncoder()

        do {
            let jsonData = try jsonEncoder.encode(body)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String: Any] {
                return dictFromJSON
            }
        } catch {
            debugPrint("[Resource] encoding to json failed")
        }
        return nil
    }
    
    func getData() -> Body? {
        guard let method = method, case let .post(body) = method else { return nil }
        return body
    }
}
