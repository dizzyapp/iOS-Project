//
//  PlaceStory.swift
//  Dizzy
//
//  Created by stas berkman on 01/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

struct PlaceStory: Codable {
    var downloadLink: String?
    
    public func isVideo() -> Bool {
        return downloadLink?.contains(".mp4") ?? false
    }
}
