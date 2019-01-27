//
//  NSMenuItem.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

private var NSMenuItemActionHelper: UInt8 = 0

extension NSMenuItem {
    
    convenience init(title: String, handler: @escaping () -> Void) {
        self.init(title: title, action: nil, keyEquivalent: "")
        
        let helper = ActionHelper(handler: handler)
        self.target = helper
        self.action = #selector(ActionHelper.action(_:))
        
        setAssociatedObject(helper, forKey: &NSMenuItemActionHelper)
    }
    
    convenience init(title: String, submenu: NSMenu) {
        self.init(title: title, action: nil, keyEquivalent: "")
        self.submenu = submenu
    }
    
}

fileprivate class ActionHelper: NSObject {
    
    private let handler: () -> Void
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
        super.init()
    }
    
    @objc func action(_ sender: Any) {
        handler()
    }
    
}
