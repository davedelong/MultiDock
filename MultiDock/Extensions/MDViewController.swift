//
//  MDViewController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class MDViewController: NSViewController {
    
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
        
    }
    
    open func viewDidMoveToSuperview(_ superview: NSView?) { }
    
    open func viewDidMoveToWindow(_ window: NSWindow?) { }
    
}

open class MDView: NSView {
    
    fileprivate(set) weak var controller: MDViewController?
    
    override open func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        controller?.viewDidMoveToSuperview(self.superview)
    }
    
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        controller?.viewDidMoveToWindow(self.window)
    }
    
}

