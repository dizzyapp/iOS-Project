//
//  LoadinContainer.swift
//  Dudies
//
//  Created by Tal Ben Asuli on 24/04/2019.
//  Copyright © 2019 Dudies. All rights reserved.
//

import UIKit

protocol AlertPresentation {
    func showAlert(title: String,
                   message: String?,
                   okButtonTitle: String?,
                   okButtonHandler: ((UIAlertAction) -> Void)?,
                   cancelButtonTitle: String?,
                   cancelButtonHandler: ((UIAlertAction) -> Void)?)
}

extension AlertPresentation where Self: UIViewController {
    
    func showAlert(title: String,
                   message: String? = nil,
                   okButtonTitle: String? = "Ok".localized,
                   okButtonHandler: ((UIAlertAction) -> Void)? = nil,
                   cancelButtonTitle: String? = nil,
                   cancelButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let okButtonTitle = okButtonTitle, !okButtonTitle.isEmpty {
            alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: okButtonHandler))
        }
        if let cancelButtonTitle = cancelButtonTitle, !cancelButtonTitle.isEmpty {
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelButtonHandler))
        }
        
        present(alert, animated: true)
    }
}
