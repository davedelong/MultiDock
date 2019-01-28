//
//  ClickableItem.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class ClickableItem: MDViewController {

    private let item: DockItem
    private let itemHeight: NSLayoutGuide
    
    @IBOutlet private var image: NSImageView?
    @IBOutlet private var runningIndicator: NSProgressIndicator?
    
    private lazy var nameLabel: NSTextField = {
        let l = NSTextField(labelWithString: item.name.value)
        l.font = NSFont.menuBarFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var namePopover: NSPopover = {
        let p = NSPopover()
        p.behavior = .applicationDefined
        p.animates = false
        let v = NSViewController()
        let c = NSView()
        c.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: c.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: c.topAnchor, constant: 4),
            nameLabel.centerXAnchor.constraint(equalTo: c.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: c.centerYAnchor)
        ])
        v.view = c
        p.contentViewController = v
        return p
    }()
    
    convenience init(app: NSRunningApplication, guide: NSLayoutGuide) {
        self.init(item: Application(runningApplication: app), guide: guide)
    }
    
    init(item: DockItem, guide: NSLayoutGuide) {
        self.item = item
        self.itemHeight = guide
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        item.icon.observe { [weak self] icon in
            self?.image?.image = icon
        }
        
        item.isRunning.observe { [weak self] state in
            self?.runningIndicator?.isHidden = (state == nil)
            self?.runningIndicator?.doubleValue = (state == true) ? 100 : 0
        }
    }
    
    override func viewDidAppear() {
        view.heightAnchor.constraint(equalTo: itemHeight.heightAnchor).isActive = true
    }
    
    override func singleClickAction(_ sender: Any) {
        item.clickHandler()
    }
    
    override func updateViewTrackingAreas() {
        let area = NSTrackingArea(rect: view.bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        view.addTrackingArea(area)
    }
    
    override func rightClickAction(_ sender: Any) {
        guard let m = item.rightClickMenu() else { return }
        if namePopover.isShown { namePopover.close() }
        NSMenu.popUpContextMenu(m, with: NSApp.currentEvent!, for: view)
    }
    
    override func mouseEntered(with event: NSEvent) {
        nameLabel.stringValue = item.name.value
        namePopover.show(relativeTo: view.bounds, of: view, preferredEdge: .maxY)
    }
    
    override func mouseExited(with event: NSEvent) {
        namePopover.close()
    }
    
}
