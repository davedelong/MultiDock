//
//  Trash.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class Trash: DockItem {
    
    
    static let user = Trash()
    
    let name: Observable<String>
    
    var icon: Observable<NSImage>
    
    var isRunning: Observable<Bool?>
    
    var clickHandler: () -> Void
    
    private init() {
        name = Observable(value: "Trash")
        isRunning = Observable(value: nil)
        icon = Observable(value: NSImage(named: NSImage.trashFullName)!)
        
        let url = try! FileManager.default.url(for: .trashDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        clickHandler = {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
    
}
