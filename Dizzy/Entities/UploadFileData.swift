//
//  UploadFileData.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 30/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

struct UploadFileData: Codable {
    var data: Data?
    var fileURL: URL?
    
    init(data: Data?, fileURL: URL?) {
        self.data = data
        self.fileURL = fileURL
    }
}
