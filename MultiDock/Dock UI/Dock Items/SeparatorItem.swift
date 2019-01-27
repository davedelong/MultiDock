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
        mdView.cursor = .resizeUpDown
    }
    
    override func viewDidAppear() {
        preferredHeight.isActive = true
    }
    
    @IBAction func panned(_ sender: NSPanGestureRecognizer) {
        print("panning")
    }
    
}
