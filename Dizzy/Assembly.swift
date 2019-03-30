//
//  Assembly.swift
//  Dizzy
//
//  Created by Or Menashe on 30/03/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Swinject
import SwinjectAutoregistration

protocol ContainerResolver {
    func resolve<T>(type: T.Type) -> T
    func terminate()
}

class Assembly {
    private let container = Container()
    
    public func registerDependencies() {
        
    }
    
    func terminate() {
        self.container.removeAll()
    }
    
}
