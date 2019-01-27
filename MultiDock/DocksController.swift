//
//  DocksController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

class DocksController {
    
    private var docks = Dictionary<CGDirectDisplayID, DockWindowController>()
    private let configurationController = DockConfigurationController()
    
    init() {
        
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
    
}
