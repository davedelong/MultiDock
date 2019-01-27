//
//  DockItemStackViewController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class DockItemStackViewController: MDViewController {

    @IBOutlet private var stackView: NSStackView?
    
    private var apps = Array<NSRunningApplication>()
    private var tiles = Array<DockItem>()
    private let guide = NSLayoutGuide()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addLayoutGuide(guide)
    }
    
    func displayApps(_ newApps: Array<NSRunningApplication>) {
        guard newApps != apps else { return }
        
        tiles.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        
        
        apps = newApps
        tiles = newApps.map { DockItem(app: $0, guide: guide) }
        tiles.forEach {
            addChild($0)
            stackView?.addView($0.view, in: .center)
        }
    }
    
}
