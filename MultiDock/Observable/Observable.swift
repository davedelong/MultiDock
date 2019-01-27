//
//  Observable.swift
//  MultiDock
//
//  Created by Dave DeLong on 1/26/19.
//  Copyright © 2019 Syzygy. All rights reserved.
//

import Foundation

// Note: This class is not threadsafe
// However, since this app is pretty much pure UI, everything will be happening on the main thread
class Observable<T> {
    typealias Token = UUID
    typealias Observer = (T) -> Void
    
    fileprivate var _value: T
    private var _observers = Dictionary<Token, Observer>()
    
    var value: T { return _value }
    
    init(value: T) {
        _value = value
    }
    
    @discardableResult
    func observe(_ observer: @escaping Observer) -> Token {
        let token = observeNext(observer)
        observer(_value)
        return token
    }
    
    @discardableResult
    func observeNext(_ observer: @escaping Observer) -> Token {
        let token = UUID()
        _observers[token] = observer
        return token
    }
    
    func removeObserver(_ token: Token) {
        _observers.removeValue(forKey: token)
    }
    
    internal func setValue(_ newValue: T) {
        _value = newValue
        for (_, observer) in _observers {
            observer(newValue)
        }
    }
    
}

class MutableObservable<T>: Observable<T> {
    
    override var value: T {
        get { return super.value }
        set { setValue(newValue) }
    }
    
    func modify(_ modifier: (T) -> T?) {
        if let newValue = modifier(_value) {
            setValue(newValue)
        }
    }
    
}
