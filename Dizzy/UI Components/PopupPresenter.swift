//
//  PopupPresenter.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

enum PopupButtonLayer {
    case oneButton(buttonText: String, onClick: (() -> Void)?)
    case towButtons(confirmText: String, cancelText: String, confirmClicked: (() -> Void)?, cancelClicked: (() -> Void)?)
}

protocol PopupPresenter {
    func showPopup(with title: String, message: String, buttonsLayer: PopupButtonLayer)
}

extension PopupPresenter where Self: UIViewController {
    
    func showPopup(with title: String, message: String, buttonsLayer: PopupButtonLayer) {
        var actions = [UIAlertAction]()
        
        switch buttonsLayer {
        case .oneButton(buttonText: let text, onClick: let completion):
            let cancelAction = UIAlertAction(title: text, style: .default) { _ in
                completion?()
            }
            actions.append(cancelAction)
            
        case .towButtons(confirmText: let confirmText, cancelText: let cancelText, confirmClicked: let confirmCompletion, cancelClicked: let cancelCompletion):
            
            let cancelAction = UIAlertAction(title: cancelText, style: .default) { _ in
                cancelCompletion?()
            }
            let confirmAction = UIAlertAction(title: confirmText, style: .default) { _ in
                confirmCompletion?()
            }
            actions.append(cancelAction)
            actions.append(confirmAction)
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
}
