//
//  FirebaseWebService.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 05/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

final class FirebaseWebService: WebServiceType {
    private let databaseReference: DatabaseReference
    let storageReference: StorageReference
    
    init() {
        FirebaseApp.configure()
        databaseReference = Database.database().reference()
        storageReference = Storage.storage().reference()
    }
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        guard let method = resource.method else { return }
        
        switch method {
        case .get:
            sendGetRequest(resource: resource, completion: completion)
            
        case .post:
            sendPostRequest(resource: resource, completion: completion)
            
        case .delete:
            sendDeleteRequest(resource: resource, completion: completion)
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

            databaseReference.child("\(resource.path)").setValue(json) { (error, _) in
                if let error = error {
                    completion(Result<Response>.failure(error))
                } else if let response = Result.success("") as? Result<Response> {
                    completion(response)
                }
            }
        }
    }
    
    private func sendDeleteRequest<Response, Body>(resource: Resource<Response, Body>,
                                                                  completion: @escaping (Result<Response>) -> Void) {
        databaseReference.child(resource.path).removeValue { (error, _) in 
            if error != nil {
                completion(Result<Response>.failure(error!))
            }
        }
    }
    
    func uplaodFile(with path: String, data: UploadFileData,  completion: @escaping (Result<UploadFileResponse>) -> Void) {
        let ref = storageReference.child(path)
        let uploadTask = ref.putData(data.data, metadata: nil) { (_, error) in
            if let error = error {
                completion(Result.failure(error))
            } else {
                self.getDownloadURL(from: ref, completion: completion)
            }
            print("UplaodFile FINISHED !!!!")
        }
        
        uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress.debugDescription)
        }
        
        uploadTask.resume()
    }
    
    private func getDownloadURL(from ref: StorageReference, completion: @escaping (Result<UploadFileResponse>) -> Void) {
        ref.downloadURL { (url, error) in
            if let error = error {
                completion(Result.failure(error))
            } else {
                let response = UploadFileResponse(downloadLink: url?.absoluteString ?? "")
                completion(Result.success(response))
            }
        }
    }
    
    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        return resource.path != "signupWithDizzy" && resource.path != "signInWithDizzy" && resource.path != "getGMSPlace"
    }
    
    private func getJsonToParse(from snapshot: DataSnapshot) -> [[String: Any]]? {
        guard let jsonsArray = snapshot.value as? [String: Any] else {
            return nil
        }
        
        var jsonToParse = [[String: Any]]()
        for (_,value) in jsonsArray {
            let valueMap = value as! [String : Any]
            jsonToParse.append(valueMap)
        }
        return jsonToParse
    }
}
