//
//  Dictionary.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

extension Dictionary {
    
    init<C: Collection>(keying items: C, by keyer: (C.Element) -> Key?) where C.Element == Value {
        self.init(minimumCapacity: items.count)
        for item in items {
            if let key = keyer(item) {
                self[key] = item
            }
        }
    }
    
    init<C>(grouping values: C, by keyForValue: (C.Element) -> Key?) where Value == [C.Element], C : Collection {
        self.init()
        
        for value in values {
            if let key = keyForValue(value) {
                var existing = self[key] ?? Array<C.Element>()
                existing.append(value)
                self[key] = existing
            }
        }
        
    }
    
}
