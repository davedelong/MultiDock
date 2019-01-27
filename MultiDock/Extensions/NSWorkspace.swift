//
//  NSWorkspace.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

extension NSWorkspace {
    
    func emptyTrash() {
        let source = """
tell application "Finder"
    if length of (items in the trash as string) is 0 then return
    empty trash
    repeat until (count of items of trash) = 0
        delay 1
    end repeat
end tell
"""
        
        let script = NSAppleScript(source: source)
        script?.executeAndReturnError(nil)
    }
    
    func hideAllApplications(except app: NSRunningApplication) {
        for thisApp in runningApplications {
            if thisApp == app { continue }
            if thisApp == NSRunningApplication.current { continue }
            thisApp.hide()
        }
    }
}
