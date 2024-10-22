//
//  Stored + Key.swift
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation


extension Stored {
    
    public typealias Keys = AnyKey
    
    public class AnyKey {
        public typealias Key = Stored.Key<Value>
        let name: String
        init(name: String) {
            self.name = name
        }
    }
    
    public class Key<V>: AnyKey {}
    
    public init(_ key: Stored<Value>.Keys) where Value: Codable {
        self.init(key.name)
    }
    
    public init(wrappedValue: Value, _ key: Stored<Value>.Keys) where Value: Codable {
        self.init(wrappedValue: wrappedValue, key.name)
    }
}
