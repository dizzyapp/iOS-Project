//
//  Coordinator.swift
//  Dizzy
//
//  Created by Or Menashe on 31/03/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import Swinject

protocol Coordinator: class {
    var container: Container? { get }
    var childCoordinators: [CoordinatorKey: Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(coordinator: Coordinator, for key: CoordinatorKey) {
        assert(childCoordinators[key] == nil)
        childCoordinators[key] = coordinator
    }
    
    func removeCoordinator(for key: CoordinatorKey) {
        childCoordinators[key] = nil
    }
}
