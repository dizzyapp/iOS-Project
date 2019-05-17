//
//  CommentView.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 07/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol CommentsViewDelegate: class {
    func commentsViewPressed()
}

final class CommentsView: UIView {
    
    weak var delegate: CommentsViewDelegate?
 
    init() {
        super.init(frame: .zero)
        addDarkBlur()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewPressed() {
        delegate?.commentsViewPressed()
    }
}
