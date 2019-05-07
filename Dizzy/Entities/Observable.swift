//
//  Observable.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

final class Observable<ObservedType> {
    typealias Observer = (ObservedType) -> Void
    
    private var observers: [Observer]
    
    var value: ObservedType {
        didSet {
            notifyObservers(value)
        }
    }
    
    init(_ value: ObservedType) {
        self.value = value
        observers = []
    }
    
    func bind(shouldObserveIntial: Bool = false, observer: @escaping Observer) {
        self.observers.append(observer)
        if shouldObserveIntial {
            observer(value)
        }
    }
    
    private func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { (observer) in
            observer(value)
        }
    }
}
