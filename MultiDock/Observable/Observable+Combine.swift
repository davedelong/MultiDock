//
//  Observable+Combine.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

extension Observable {
    
    func combine<U>(_ other: Observable<U>) -> Observable<(T, U)> {
        var combinedValue = (value, other.value)
        let combined = MutableObservable(value: combinedValue)
        
        observeNext {
            combinedValue.0 = $0
            combined.value = combinedValue
        }
        
        other.observeNext {
            combinedValue.1 = $0
            combined.value = combinedValue
        }
        
        return combined
        
    }
    
}
