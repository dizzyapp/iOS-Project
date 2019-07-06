//
//  CommentsManager.swift
//  Dizzy
//
//  Created by stas berkman on 06/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsManagerDelegate: class {
    func commentView(isHidden: Bool)
    func commentsManagerSendPressed(_ manager: CommentsTextFieldInputView, with message: String)
}

protocol CommentsManagerDataSource: class {
    func numberOfRowsInSection() -> Int
    func comment(at indexPath: IndexPath) -> Comment?
}

class CommentsManager: NSObject {

}
