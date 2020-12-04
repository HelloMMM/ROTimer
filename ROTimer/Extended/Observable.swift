//
//  Observable.swift
//  Observable
//
//  Created by Sandy Huang on 2020/6/1.
//  Copyright © 2020 Sandy Huang. All rights reserved.
//

import Foundation

public final class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(fireNow: Bool = false, _ observer: Observer?) {
        self.observer = observer
        if fireNow {
            observer?(value)
        }
    }
    
    func removeObserver() {
        self.observer = nil
    }
}

