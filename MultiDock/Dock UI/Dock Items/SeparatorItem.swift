//
//  SeparatorItem.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

class SeparatorItem: MDViewController {

    private let preferredHeight: NSLayoutConstraint
    private var startingPreferredHeight: CGFloat = 0
    
    init(guide: NSLayoutGuide) {
        preferredHeight = guide.heightAnchor.constraint(equalToConstant: 64)
        preferredHeight.priority = .init(rawValue: 999)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = NSPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        view.addGestureRecognizer(pan)
    }
    
    override func viewDidAppear() {
        preferredHeight.isActive = true
    }
    
    override func updateViewTrackingAreas() {
        let area = NSTrackingArea(rect: view.bounds, options: [.activeAlways, .cursorUpdate], owner: self, userInfo: nil)
        view.addTrackingArea(area)
    }
    
    override func cursorUpdate(with event: NSEvent) {
        NSCursor.resizeUpDown.set()
    }
    
    @IBAction func panned(_ sender: NSPanGestureRecognizer) {
        if sender.state == .began {
            startingPreferredHeight = preferredHeight.constant
        }
        
        let translation = sender.translation(in: nil)
        
        let yDifference = translation.y * 0.25
        preferredHeight.constant = startingPreferredHeight + yDifference
    }
    
}
