//
//  Display.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation
import Quartz
import IOKit

private func CGDisplayName(_ display: CGDirectDisplayID) -> String {
    let vendorID = CGDisplayVendorNumber(display)
    let productID = CGDisplayModelNumber(display)
    
    
    let matchingDisplays = IOServiceMatching("IODisplayConnect")
    var iterator: io_iterator_t = 0
    
    let result = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDisplays, &iterator)
    guard result == kIOReturnSuccess else { return "\(display)" }
    guard iterator != 0 else { return "\(display)" }
    
    var service = IOIteratorNext(iterator)
    while service != 0 {
        defer { service = IOIteratorNext(iterator) }
        
        let unmanagedCFInfo = IODisplayCreateInfoDictionary(service, IOOptionBits(kIODisplayOnlyPreferredName))
        guard let cfInfo = unmanagedCFInfo?.takeRetainedValue() else { continue }
        guard let info = cfInfo as? Dictionary<String, Any> else { continue }
        
        let thisVendor = info[kDisplayVendorID] as? UInt32 ?? 0
        let thisProduct = info[kDisplayProductID] as? UInt32 ?? 0
        
        guard thisVendor == vendorID else { continue }
        guard thisProduct == productID else { continue }
        
        guard let productNameInfo = info[kDisplayProductName] as? Dictionary<String, String> else { continue }
        
        // TODO: probably want a preferred language first
        
        if let (_, name) = productNameInfo.first { return name }
        
        break
    }
    
    return "\(display)"
}

struct Display: Hashable {
    
    let displayID: CGDirectDisplayID
    let name: String
    let bounds: CGRect
    
    init(displayID: CGDirectDisplayID) {
        self.displayID = displayID
        self.bounds = CGDisplayBounds(displayID)
        self.name = CGDisplayName(displayID)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(displayID)
        hasher.combine(bounds.origin.x)
        hasher.combine(bounds.origin.y)
        hasher.combine(bounds.size.width)
        hasher.combine(bounds.size.height)
    }
    
}
