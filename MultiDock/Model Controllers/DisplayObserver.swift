//
//  DisplayObserver.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation
import Quartz

private func DisplayConfigurationDidChange(_ displayID: CGDirectDisplayID, _ change: CGDisplayChangeSummaryFlags, _ context: UnsafeMutableRawPointer?) {
    guard let raw = context else { return }
    let displayObserver = Unmanaged<DisplayObserver>.fromOpaque(raw).takeUnretainedValue()
    displayObserver.displaysChanged()
}

class DisplayObserver {
    
    private let _latestDisplays = MutableObservable<Set<Display>>(value: [])
    let displays: Observable<Set<Display>>
    
    init() {
        displays = _latestDisplays.skipRepeats()
        
        let pointer = Unmanaged.passUnretained(self).toOpaque()
        CGDisplayRegisterReconfigurationCallback(DisplayConfigurationDidChange, pointer)
        
        displaysChanged()
    }
    
    deinit {
        let pointer = Unmanaged.passUnretained(self).toOpaque()
        CGDisplayRemoveReconfigurationCallback(DisplayConfigurationDidChange, pointer)
    }
    
    fileprivate func displaysChanged() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                 self.displaysChanged()
            }
            return
        }
        
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount)
        
        let buf = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: Int(displayCount))
        var actualCount: UInt32 = 0
        CGGetActiveDisplayList(displayCount, buf, &actualCount)
        
        let displayIDs = Array(UnsafeBufferPointer(start: buf, count: Int(actualCount)))
        buf.deallocate()
        
        let newDisplays = Set(displayIDs.map { Display(displayID: $0) })
        _latestDisplays.value = newDisplays
    }
    
}
