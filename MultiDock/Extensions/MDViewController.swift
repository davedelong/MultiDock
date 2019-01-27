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
    private var rightClickRecognizer: NSClickGestureRecognizer?
    
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
            view.autoresizingMask = [.width, .height]
            view.translatesAutoresizingMaskIntoConstraints = true
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
        
        if overrides(#selector(rightClickAction(_:)), upTo: MDViewController.self) {
            let r = NSClickGestureRecognizer(target: self, action: #selector(rightClickAction(_:)))
            r.numberOfClicksRequired = 1
            r.buttonMask = 0x2
            r.delaysPrimaryMouseButtonEvents = false
            view.addGestureRecognizer(r)
            rightClickRecognizer = r
        }
        
    }
    
    open func viewDidMoveToSuperview(_ superview: NSView?) { }
    
    open func viewDidMoveToWindow(_ window: NSWindow?) { }
    
    @objc open func rightClickAction(_ sender: Any) { }
    
    @objc open func viewDidResize(_ notification: Notification) { }
    
}

open class MDView: NSView {
    
    fileprivate(set) weak var controller: MDViewController?
    
    var cursor: NSCursor?
    
    open override var acceptsFirstResponder: Bool {
        let superAccepts = super.acceptsFirstResponder
        return superAccepts || cursor != nil || gestureRecognizers.isEmpty == false
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

