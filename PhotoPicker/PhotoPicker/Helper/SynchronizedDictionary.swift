//
//  SynchronizedDictionary.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation

public class SynchronizedDictionary<K:Hashable,V> {
    private var dictionary: [K:V] = [:]
    private let accessQueue = DispatchQueue(label: "SynchronizedDictionaryAccess",
                                            attributes: .concurrent)
    
    deinit {
        //print("deinit SynchronizedDictionary")
    }
    
    public func removeAll() {
        self.accessQueue.async(flags:.barrier) {
            self.dictionary.removeAll()
        }
    }
    
    public func removeValue(forKey: K) {
        self.accessQueue.async(flags:.barrier) {
            self.dictionary.removeValue(forKey: forKey)
        }
    }
    
    public func forEach(_ closure: ((K,V) -> Void)) {
        self.accessQueue.sync {
            self.dictionary.forEach{ arg in
                let (key, value) = arg
                closure(key,value)
            }
        }
    }
    
    public subscript(key: K) -> V? {
        set {
            self.accessQueue.async(flags:.barrier) {
                self.dictionary[key] = newValue
            }
        }
        get {
            var element: V?
            self.accessQueue.sync {
                element = self.dictionary[key]
            }
            return element
        }
    }
}
