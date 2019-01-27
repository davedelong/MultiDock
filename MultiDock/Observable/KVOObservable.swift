//
//  KVOObservable.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/27/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

fileprivate var KVOObservableContext: UInt8 = 0

fileprivate class KVOHelper<T>: NSObject {
    
    private weak var obj: NSObject?
    private let keyPath: String
    var setter: ((T) -> Void)?
    
    init(object: NSObject, keyPath: String) {
        self.obj = object
        self.keyPath = keyPath
        
        super.init()
        
        object.addObserver(self, forKeyPath: keyPath, options: [], context: &KVOObservableContext)
        object.addDeallocHandler { [weak self, weak object] in
            guard let s = self else { return }
            guard let o = object else { return }
            o.removeObserver(s, forKeyPath: keyPath, context: &KVOObservableContext)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &KVOObservableContext else { return }
        guard let observed = object as? NSObject else { return }
        guard observed == obj else { return }
        guard keyPath == self.keyPath else { return }
        guard let value = obj?.value(forKeyPath: self.keyPath) as? T else { return }
        
        setter?(value)
    }
    
}

class KVOObservable<T>: Observable<T> {
    
    private let helper: KVOHelper<T>
    
    init(object: NSObject, keyPath: String, initialValue: T) {
        helper = KVOHelper(object: object, keyPath: keyPath)
        
        let kpValue = (object.value(forKeyPath: keyPath) as? T) ?? initialValue
        
        super.init(value: kpValue)
        
        helper.setter = { [weak self] in
            self?.setValue($0)
        }
    }
    
}
