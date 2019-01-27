//
//  AppDelegate.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/25/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa
import Quartz

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var docks: DocksController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        docks = DocksController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

