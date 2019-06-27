//
//  LoadinContainer.swift
//  Dudies
//
//  Created by Tal Ben Asuli on 24/04/2019.
//  Copyright © 2019 Dudies. All rights reserved.
//

import UIKit

protocol Spinnable {
    func startAnimating()
    func stopAnimating()
}

protocol LoadingContainer {
    var spinner: UIView & Spinnable { get }
    
    func addSpinner()
    func showSpinner()
    func hideSpinner()
}

extension LoadingContainer where Self: UIViewController {
    
    func addSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        spinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        spinner.isHidden = true
    }
    
    func showSpinner() {
        addSpinner()
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}

extension UIActivityIndicatorView: Spinnable {
    class func withAppStyle() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.backgroundColor = UIColor.lightGray
        return view
    }
}
