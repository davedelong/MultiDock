//
//  DockItem.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class DockItem: NSCollectionViewItem {

    private let app: NSRunningApplication
    private let itemHeight: NSLayoutGuide
    
    init(app: NSRunningApplication, guide: NSLayoutGuide) {
        self.app = app
        self.itemHeight = guide
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.image = app.icon
    }
    
    override func viewDidAppear() {
        view.heightAnchor.constraint(equalTo: itemHeight.heightAnchor).isActive = true
    }
    
}
