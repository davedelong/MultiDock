//
//  Application.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class Application: DockItem {
    let name: Observable<String>
    let icon: Observable<NSImage>
    let isRunning: Observable<Bool?>
    let clickHandler: () -> Void
    
    init(runningApplication: NSRunningApplication) {
        let n = runningApplication.localizedName ?? runningApplication.bundleIdentifier ?? "Unknown"
        
        name = Observable(value: n)
        icon = Observable(value: runningApplication.icon ?? NSImage(named: NSImage.applicationIconName)!)
        isRunning = Observable(value: true)
        
        clickHandler = { runningApplication.activate(options: []) }
    }
    
}
