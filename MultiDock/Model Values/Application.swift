//
//  Application.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class Application: DockItem {
    let name: Observable<String>
    let icon: Observable<NSImage>
    let isRunning: Observable<Bool?>
    let clickHandler: () -> Void
    
    private let app: NSRunningApplication
    private let appURL: URL?
    
    init(runningApplication: NSRunningApplication) {
        let n = runningApplication.localizedName ?? runningApplication.bundleIdentifier ?? "Unknown"
        
        name = Observable(value: n)
        icon = Observable(value: runningApplication.icon ?? NSImage(named: NSImage.applicationIconName)!)
        isRunning = Observable(value: true)
        appURL = runningApplication.bundleURL
        app = runningApplication
        
        clickHandler = { runningApplication.activate(options: []) }
    }
    
    func rightClickMenu() -> NSMenu? {
        let m = NSMenu()
        
        if let url = appURL {
            let optionsSubMenu = NSMenu()
            optionsSubMenu.addItem(NSMenuItem(title: "Show in Finder", handler: {
                NSWorkspace.shared.activateFileViewerSelecting([url])
            }))
            let options = NSMenuItem(title: "Options", submenu: optionsSubMenu)
            m.addItem(options)
            m.addItem(.separator())
        }
        
        let r = app
        m.addItem(NSMenuItem(title: "Show All Windows", handler: {
            r.activate(options: [.activateAllWindows])
        }))
        
        if r.isHidden {
            m.addItem(NSMenuItem(title: "Show", handler: {
                r.activate(options: [])
            }))
        } else {
            m.addItem(NSMenuItem(title: "Hide", handler: {
                r.hide()
            }))
            let hideOthers = NSMenuItem(title: "Hide Others", handler: {
                NSWorkspace.shared.hideAllApplications(except: r)
            })
            hideOthers.isAlternate = true
            m.addItem(hideOthers)
        }
        
        m.addItem(NSMenuItem(title: "Quit", handler: {
            r.terminate()
        }))
        let forceQuit = NSMenuItem(title: "Force Quit", handler: {
            r.forceTerminate()
        })
        forceQuit.isAlternate = true
        m.addItem(forceQuit)
        
        return m
    }
    
}
