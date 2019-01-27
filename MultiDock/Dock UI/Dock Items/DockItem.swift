//
//  DockItem.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Cocoa

protocol DockItem {
    var name: Observable<String> { get }
    var icon: Observable<NSImage> { get }
    var isRunning: Observable<Bool?> { get }
    var clickHandler: () -> Void { get }
}
