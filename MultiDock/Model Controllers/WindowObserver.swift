//
//  WindowObserver.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/25/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class WindowObserver {
    
    private var timer: Timer!
    private var latestSetOfWindows = Set<Window>()
    private let _latestWindows = MutableObservable<Set<Window>>(value: [])
    
    let windows: Observable<Set<Window>>
    
    init() {
        guard Thread.isMainThread else { fatalError("WindowObserver must be created on the main thread") }
        windows = _latestWindows.skipRepeats()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] t in
            self?.recheckWindows()
        }
    }
    
    private func recheckWindows() {
        guard let results = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) else { return }
        let nsResults = results as NSArray
        guard let typedResults = nsResults as? Array<Dictionary<CFString, Any>> else { return }
        
        let windows = typedResults.compactMap(Window.init(windowDefinition:))
        
        let runningApps = NSWorkspace.shared.runningApplications
        let dockApps = runningApps.filter { $0.activationPolicy == .regular }
        
        let appsByPIDs = Dictionary(grouping: dockApps, by: { $0.processIdentifier })
        
        let appWindows = windows.filter { appsByPIDs[$0.owner] != nil }
        
        _latestWindows.value = Set(appWindows)
    }
    
}
