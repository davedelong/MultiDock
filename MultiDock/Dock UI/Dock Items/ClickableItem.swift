//
//  ClickableItem.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class ClickableItem: NSCollectionViewItem {

    private let item: DockItem
    private let itemHeight: NSLayoutGuide
    
    @IBOutlet private var button: NSButton?
    @IBOutlet private var runningIndicator: NSButton?
    
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
            self?.button?.image = icon
        }
        
        item.isRunning.observe { [weak self] state in
            self?.runningIndicator?.isHidden = (state == nil)
            self?.runningIndicator?.state = (state == true) ? .on : .off
        }
    }
    
    override func viewDidAppear() {
        view.heightAnchor.constraint(equalTo: itemHeight.heightAnchor).isActive = true
    }
    
    @IBAction func clickedButton(_ sender: NSButton) {
        item.clickHandler()
    }
    
}
