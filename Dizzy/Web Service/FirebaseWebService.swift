//
//  FirebaseWebService.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseWebService: WebServiceType {
    private let databaseReference: DatabaseReference
    
    init() {
        FirebaseApp.configure()
        databaseReference = Database.database().reference()
    }
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        guard let method = resource.method else { return }
        
        switch method {
        case .get:
            sendGetRequest(resource: resource, completion: completion)
            
        case .post:
            sendPostRequest(resource: resource, completion: completion)
        }
    }
    
    private func sendGetRequest<Response, Body>(resource: Resource<Response, Body>,
                                                completion: @escaping (Result<Response>) -> Void) {
        databaseReference.child(resource.path).observe(DataEventType.value) { snapshot in
            do {
                guard let jsonToParse = self.getJsonToParse(from: snapshot) else {
                    completion(Result<Response>.failure(WebServiceError.noData))
                    return
                }
                
                let data = try JSONSerialization.data(withJSONObject: jsonToParse, options: .prettyPrinted)
                let parsedData = try resource.parse(data: data)
                completion(Result<Response>.success(parsedData))
            } catch let jsonError {
                completion(Result<Response>.failure(jsonError))
            }
        }
    }
    
    private func sendPostRequest<Response, Body>(resource: Resource<Response, Body>,
                                                 completion: @escaping (Result<Response>) -> Void) {
        if let json = resource.makeJson() {
            databaseReference.child("\(resource.path)/\(UUID())").setValue(json) { (error, _) in
                if error != nil {
                    completion(Result<Response>.failure(error))
                }
            }
        }
    }

    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        return true
    }
    
    private func getJsonToParse(from snapshot: DataSnapshot) -> [[String: Any]]? {
        guard let jsonsArray = snapshot.value as? [String: Any] else {
            return nil
        }
        
        var jsonToParse = [[String: Any]]()
        for (_,value) in jsonsArray {
            jsonToParse.append(value as! [String : Any])
        }
        return jsonToParse
    }
}
