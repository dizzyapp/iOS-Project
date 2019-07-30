//
//  ExternalNavigationProvider.swift
//  Dizzy
//
//  Created by stas berkman on 04/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class ExternalNavigationProvider {

    func openWaze(location : Location) {
        if let url = URL(string: "waze://"), UIApplication.shared.canOpenURL(url) {
            let urlStr: String = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
            if let url = URL(string: urlStr) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Waze is not installed. Launch AppStore to install Waze app
            if let url = URL(string: "http://itunes.apple.com/us/app/id323229106") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
