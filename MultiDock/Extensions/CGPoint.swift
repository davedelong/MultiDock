//
//  CGPoint.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

extension CGPoint {
    
    func distance(to other: CGPoint) -> CGFloat {
        let xDistance = x - other.x
        let yDistance = y - other.y
        return sqrt((xDistance * xDistance) + (yDistance * yDistance))
    }
    
}
