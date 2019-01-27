//
//  DockWindowController.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class DockWindowController: NSWindowController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    private var configuration: DockConfiguration
    
    @IBOutlet private var collectionView: NSCollectionView?
    @IBOutlet private var stackView: NSStackView?
    
    private var tiles = Array<DockItem>()
    
    override var windowNibName: NSNib.Name? { return "DockWindowController" }
    
    init(configuration: DockConfiguration) {
        self.configuration = configuration
        super.init(window: nil)
        
        showWindow(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with newConfiguration: DockConfiguration) {
        guard newConfiguration.display.displayID == configuration.display.displayID else { return }
        if newConfiguration == configuration { return }
        
        configuration = newConfiguration
        collectionView?.reloadData()
        positionWindow()
        
        tiles = newConfiguration.apps.map { DockItem(app: $0.0) }
        stackView?.setViews(tiles.map { $0.view }, in: .center)
    }
    
    private func positionWindow() {
        guard let w = window else { return }
        
        let centerX = configuration.display.bounds.center.x
        
        var f = w.frame
        f.center.x = centerX
        f.origin.y = 0
        w.setFrameOrigin(f.origin)
        print("Moving dock to \(f.origin)")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // the dock is at level 20
        window?.level = NSWindow.Level(rawValue: 21)
        window?.title = configuration.display.name
        positionWindow()
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Dock for \(configuration.display.name) has \(configuration.apps.count) items")
        return configuration.apps.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let app = configuration.apps[indexPath.item]
        return DockItem(app: app.0)
    }
    
    
}
