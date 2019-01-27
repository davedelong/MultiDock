//
//  Observable+Map.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

extension Observable {
    
    func map<U>(_ mapper: @escaping (T) -> U) -> Observable<U> {
        let initial = mapper(value)
        let final = MutableObservable(value: initial)
        
        observeNext { final.value = mapper($0) }
        
        return final
    }
    
}
