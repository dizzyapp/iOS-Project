//
//  ExternalNavigationProvider.swift
//  Dizzy
//
//  Created by stas berkman on 04/07/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class ExternalNavigationProvider {
    
    enum LinkType {
        case waze(location: Location)
        case getTaxi(location: Location)

        var url: URL? {
            switch self {
            case .waze(location: let location):
                let urlStr: String = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
                return URL(string: urlStr)
                
            case .getTaxi(location: let location):
                let urlStr = "gett://order?dropoff_latitude=\(location.latitude)&dropoff_longitude=\(location.longitude)"
                return URL(string: urlStr)
            }
        }
        
        var isAppInstalled: Bool {
            let baseURLString: String
            
            switch self {
            case .waze: baseURLString = "waze://"
            case .getTaxi: baseURLString = "gett://"
            }
            
            guard let url = URL(string: baseURLString) else { return false }
            return UIApplication.shared.canOpenURL(url)
        }
        
        var appStoreURL: URL? {
            switch self {
            case .waze: return URL(string: "http://itunes.apple.com/us/app/id323229106")
            case .getTaxi: return URL(string: "https://apps.apple.com/us/app/gett-worldwide-ground-travel/id449655162")
            }
        }
    }
    
    func open(link: LinkType) {
        
        guard link.isAppInstalled else {
            if let appStoreURL = link.appStoreURL {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
            return
        }
        
        if let url = link.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
