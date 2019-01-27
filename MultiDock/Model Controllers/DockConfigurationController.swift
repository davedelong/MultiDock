//
//  DockConfigurationController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class DockConfigurationController {
    
    private let windowObserver: WindowObserver
    private let displayObserver: DisplayObserver
    
    private let combined: Observable<(Set<Window>, Set<Display>)>
    
    private let _configurations = MutableObservable<Set<DockConfiguration>>(value: [])
    let configurations: Observable<Set<DockConfiguration>>
    
    init() {
        windowObserver = WindowObserver()
        displayObserver = DisplayObserver()
        configurations = _configurations.skipRepeats()
        
        
        combined = windowObserver.windows.combine(displayObserver.displays)
        combined.observe { [weak self] (windows, displays) in
            self?.group(windows: windows, displays: displays)
        }
    }
    
    private func group(windows: Set<Window>, displays: Set<Display>) {
        guard displays.isEmpty == false else { return }
        
        let runningApps = NSWorkspace.shared.runningApplications
        let dockApps = runningApps.filter { $0.activationPolicy == .regular }.sorted { l, r -> Bool in
            switch (l.launchDate, r.launchDate) {
                case (nil, .some(_)): return false
                case (.some(_), nil): return true
                case let (leftDate?, rightDate?): return leftDate < rightDate
                default: break
            }
            
            return l.processIdentifier < r.processIdentifier
        }
        
        let appsByPID = Dictionary(keying: dockApps, by: { $0.processIdentifier })
        
        let windowsGroupedByDisplay = Dictionary(grouping: windows) { display(for: $0, from: displays) }
        
        var configurations = Set<DockConfiguration>()
        for (display, windows) in windowsGroupedByDisplay {
            let windowsGroupedByApp = Dictionary(grouping: windows) { appsByPID[$0.owner] }
            var appAndWindows = Array<(NSRunningApplication, Array<Window>)>()
            for app in dockApps {
                if let appWindows = windowsGroupedByApp[app] {
                    appAndWindows.append((app, appWindows))
                }
            }
            
            let config = DockConfiguration(display: display, apps: appAndWindows)
            configurations.insert(config)
        }
        _configurations.value = configurations
    }
    
    private func display(for window: Window, from displays: Set<Display>) -> Display {
        let windowCenter = window.bounds.center
        let sortedDisplays = displays.sorted { (d1, d2) -> Bool in
            return d1.bounds.center.distance(to: windowCenter) < d2.bounds.center.distance(to: windowCenter)
        }
        return sortedDisplays[0]
    }
    
}
