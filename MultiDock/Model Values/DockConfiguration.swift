//
//  DockConfiguration.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

struct DockConfiguration: Hashable {
    
    static func ==(lhs: DockConfiguration, rhs: DockConfiguration) -> Bool {
        guard lhs.display == rhs.display else { return false }
        guard lhs.apps.count == rhs.apps.count else { return false }
        
        let zipped = zip(lhs.apps, rhs.apps)
        
        for ((leftApp, leftWindows), (rightApp, rightWindows)) in zipped {
            if leftApp != rightApp { return false }
            if leftWindows != rightWindows { return false }
        }
        
        return true
    }
    
    let display: Display
    let apps: Array<(NSRunningApplication, Array<Window>)>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(display)
        for (app, windows) in apps {
            hasher.combine(app)
            hasher.combine(windows)
        }
    }
    
}
