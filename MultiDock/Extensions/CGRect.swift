//
//  CGRect.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

extension CGRect {
    
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
        set {
            let originX = newValue.x - (width / 2.0)
            let originY = newValue.y - (height / 2.0)
            origin = CGPoint(x: originX, y: originY)
        }
    }
    
}
