//
//  Comment.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 03/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var id: String
    var value: String
    var timeStamp: Double
    var writerId: String
}

struct CommentWithWriter {
    var comment: Comment
    var writer: DizzyUser
}
