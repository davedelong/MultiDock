//
//  DockViewController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class DockViewController: MDViewController {

    @IBOutlet private var visualEffectView: NSVisualEffectView?
    @IBOutlet private var stackView: NSStackView?
    
    private var apps = Array<NSRunningApplication>()
    private var tiles = Array<MDViewController>()
    private let guide = NSLayoutGuide()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(macOS 10.14, *) {
            visualEffectView?.material = .underPageBackground
        }

        view.addLayoutGuide(guide)
        mdView.acceptsFirstResponder = true
        view.layer?.cornerRadius = 6
        view.layer?.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func displayApps(_ newApps: Array<NSRunningApplication>) {
        guard newApps != apps else { return }
        
        
        
        tiles.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        
        apps = newApps
        tiles = []
        
        newApps.forEach {
            addItem(ClickableItem(app: $0, guide: guide))
        }
        addItem(SeparatorItem(guide: guide))
        addItem(ClickableItem(item: Trash.user, guide: guide))
    }
    
    private func addItem(_ item: MDViewController) {
        addChild(item)
        tiles.append(item)
        stackView?.addView(item.view, in: .center)
    }
    
}
