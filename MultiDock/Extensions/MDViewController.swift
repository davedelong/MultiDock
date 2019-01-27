//
//  MDViewController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class MDViewController: NSViewController {
    
    private var isObservingFrame = false
    
    var mdView: MDView { return view as! MDView }
    
    deinit {
        if isObservingFrame {
            NotificationCenter.default.removeObserver(self, name: NSView.frameDidChangeNotification, object: view)
        }
    }
    
    open override func loadView() {
        super.loadView()
        
        let mdv: MDView
        
        if let v = view as? MDView {
            mdv = v
        } else {
            let newView = MDView(frame: view.frame)
            view.frame = newView.bounds
            newView.addSubview(view)
            
            newView.autoresizingMask = [.width, .height]
            newView.translatesAutoresizingMaskIntoConstraints = true
            view = newView
            
            mdv = newView
        }
        mdv.controller = self
        
        if overrides(#selector(viewDidResize(_:)), upTo: MDViewController.self) {
            isObservingFrame = true
            NotificationCenter.default.addObserver(self, selector: #selector(viewDidResize(_:)), name: NSView.frameDidChangeNotification, object: view)
        }
        
    }
    
    open func viewDidMoveToSuperview(_ superview: NSView?) { }
    
    open func viewDidMoveToWindow(_ window: NSWindow?) { }
    
    @objc open func viewDidResize(_ notification: Notification) { }
    
}

open class MDView: NSView {
    
    fileprivate(set) weak var controller: MDViewController?
    
    var cursor: NSCursor?
    
    open override var acceptsFirstResponder: Bool {
        let superAccepts = super.acceptsFirstResponder
        return superAccepts || cursor != nil
    }
    
    override open func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        controller?.viewDidMoveToSuperview(self.superview)
    }
    
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        controller?.viewDidMoveToWindow(self.window)
    }
    
    open override func resetCursorRects() {
        if let c = cursor {
            print("resetting rect for \(self)")
            addCursorRect(bounds, cursor: c)
        }
    }
    
}

