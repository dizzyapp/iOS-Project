//
//  PopupPresenter.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class Action {
    let title: String
    let style: UIAlertAction.Style
    let action: (() -> Void)?
    
    init(title: String,
         style: UIAlertAction.Style = .default,
         action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
        self.style = style
    }
}

protocol PopupPresenter {
    func showPopup(with title: String, message: String, actions: [Action])
    func showDizzyPopup(withMessage messgae: String, imageUrl: String?, onOk: @escaping () -> Void, onCancel: (() -> Void)?)
}

extension PopupPresenter where Self: UIViewController {
    
    func showPopup(with title: String, message: String, actions: [Action]) {
        
        var alertActions = [UIAlertAction]()
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.action?()
            }
            alertActions.append(alertAction)
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for alertAction in alertActions {
            alertController.addAction(alertAction)
        }
        alertController.modalPresentationStyle = .fullScreen
        present(alertController, animated: true)
    }
    
    func showDizzyPopup(withMessage messgae: String, imageUrl: String?, onOk: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        let popup = DizzyPopup(imageUrl: imageUrl, message: messgae)
        
        view.addSubview(popup)
        
        popup.snp.makeConstraints { popup in
            popup.edges.equalToSuperview()
        }
        
        popup.onOk = onOk
        
        popup.onCancel =  onCancel
    }
}
