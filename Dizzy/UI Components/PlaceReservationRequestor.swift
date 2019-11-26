//
//  PlaceReservationRequestor.swift
//  Dizzy
//
//  Created by Menashe, Or on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import UIKit

protocol PlaceReservationRequestor {
    func requestATable(_ placeInfo: PlaceInfo, text: String)
}

extension PlaceReservationRequestor {
    func requestATable(_ placeInfo: PlaceInfo, text: String) {
        let whatsappText = text.localized.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let phoneNumber = placeInfo.publicistPhoneNumber, !phoneNumber.isEmpty,
            let url = URL(string: "https://wa.me/\(placeInfo.publicistPhoneNumber ?? "")/?text=\(whatsappText ??    "")") else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

protocol ReserveTableDisplayer {
    func showReservation(with place: PlaceInfo)
}

extension ReserveTableDisplayer where Self: NavigationCoordinator {
    
    func showReservation(with place: PlaceInfo) {
        
        guard var viewModel = container?.resolve(ReserveTableVMType.self, argument: place),
            let viewController = container?.resolve(ReserveTableVC.self, argument: viewModel) else {
                print("could not load ReseveTableVC")
                return
        }

        let presentingVC = navigationController.viewControllers.first

        viewModel.reserveTableFinished = {
            viewController.dismiss(animated: true)
        }
        
        presentingVC?.present(viewController, animated: true)
    }
}
