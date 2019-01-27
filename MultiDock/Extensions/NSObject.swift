//
//  NSObject.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

public extension NSObject {
    
    public func overrides(_ selector: Selector, upTo targetParent: AnyClass? = nil) -> Bool {
        guard let myIMP = method(for: selector) else { return false }
        
        var parentClass: AnyClass? = type(of: self)
        while let parent = parentClass {
            let parentIMP = parent.instanceMethod(for: selector)
            
            if parentIMP != nil && parentIMP != myIMP { return true }
            if parent == targetParent { break }
            
            parentClass = class_getSuperclass(parentClass)
        }
        
        return false
    }
    
}
