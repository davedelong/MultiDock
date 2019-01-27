//
//  Observable+Skip.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

extension Observable {
    
    func skipRepeats(using isEqual: @escaping (T, T) -> Bool) -> Observable<T> {
        var previous = value
        let o = MutableObservable(value: previous)
        observeNext {
            if isEqual($0, previous) == false {
                previous = $0
                o.value = $0
            }
        }
        return o
    }
    
}

extension Observable where T: Equatable {
    
    func skipRepeats() -> Observable<T> {
        return skipRepeats(using: ==)
    }
    
}
