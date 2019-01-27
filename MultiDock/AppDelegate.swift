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
    
    private var docks = Dictionary<CGDirectDisplayID, DockWindowController>()
    private lazy var configurationController: DockConfigurationController = {
        return DockConfigurationController()
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        configurationController.configurations.observe { [weak self] configs in
            guard let self = self else { return }
            var oldDocks = Set(self.docks.keys)
            
            for config in configs {
                oldDocks.remove(config.display.displayID)
                if let existing = self.docks[config.display.displayID] {
                    // update the existing dock
                    existing.update(with: config)
                } else {
                    // create a new dock
                    let dock = DockWindowController(configuration: config)
                    self.docks[config.display.displayID] = dock
                }
            }
            
            for displayID in oldDocks {
                self.docks.removeValue(forKey: displayID)
            }
            
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

