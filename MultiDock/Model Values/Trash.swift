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
    
    private let hasItems: Observable<Bool>
    
    let name: Observable<String>
    let icon: Observable<NSImage>
    let isRunning: Observable<Bool?>
    let clickHandler: () -> Void
    
    private init() {
        name = Observable(value: "Trash")
        isRunning = Observable(value: nil)
        
        hasItems = Observable(value: true)
        icon = hasItems.map { NSImage(named: $0 ? NSImage.trashFullName : NSImage.trashEmptyName)! }
        
        let url = try! FileManager.default.url(for: .trashDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        clickHandler = {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
    
    func rightClickMenu() -> NSMenu? {
        let m = NSMenu()
        
        m.addItem(NSMenuItem(title: "Open", handler: clickHandler))
        
        m.addItem(.separator())
        
        let empty = NSMenuItem(title: "Empty Trash", handler: {
            NSWorkspace.shared.emptyTrash()
        })
        empty.isEnabled = hasItems.value
        m.addItem(empty)
        
        return m
    }
    
}
