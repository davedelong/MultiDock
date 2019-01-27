//
//  Window.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/25/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation
import Quartz

struct Window: Hashable {
    
    let windowID: CGWindowID
    let bounds: CGRect
    let owner: pid_t
    
    init?(windowDefinition: Dictionary<CFString, Any>) {
        guard let id = windowDefinition[kCGWindowNumber] as? NSNumber else { return nil }
        guard let ownerPID = windowDefinition[kCGWindowOwnerPID] as? NSNumber else { return nil }
        
        guard let boundsDict = windowDefinition[kCGWindowBounds] as? NSDictionary else { return nil }
        guard let rectValue = CGRect(dictionaryRepresentation: boundsDict as CFDictionary) else { return nil }
        
        // filter out windows that represent NSStatusBarItems
        if rectValue.minY == 0 && rectValue.height == NSStatusBar.system.thickness { return nil }
        
        windowID = id.uint32Value
        bounds = rectValue
        owner = ownerPID.int32Value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(windowID)
        hasher.combine(bounds.origin.x)
        hasher.combine(bounds.origin.y)
        hasher.combine(bounds.size.width)
        hasher.combine(bounds.size.height)
        hasher.combine(owner)
    }
    
}
