//
//  Stored + RawRepresentable.swift
//  Playground
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation

// MARK: Initializers with WrappedValue

extension Stored where Value: RawRepresentable {
    
    private init(value: Value, _ key: String)  {
        self.key = key
        self.getter = {
            if let rawValue = UserDefaults.standard.object(forKey: key) as? Value.RawValue {
                if let value = Value(rawValue: rawValue) {
                    return value
                }
            }
            fatalError("Value for key \"\(key)\" of type \"\(String(describing: Value.self))\" does not exist")
        }
        self.setter = {
            UserDefaults.standard.set($0.rawValue, forKey: key)
        }
        
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(value.rawValue, forKey: key)
        }
    }
    
    public init(wrappedValue: Value, _ key: String) where Value.RawValue == String {
        self.init(value: wrappedValue, key)
    }
    
    public init(wrappedValue: Value, _ key: String) where Value.RawValue == Int {
        self.init(value: wrappedValue, key)
    }
}

// MARK: Initializers without WrappedValue (Force!)

extension Stored where Value: RawRepresentable {
    
    private init(key: String) {
        self.key = key
        self.getter = {
            if let rawValue = UserDefaults.standard.object(forKey: key) as? Value.RawValue {
                if let value = Value(rawValue: rawValue) {
                    return value
                }
            }
            fatalError("Value for key \"\(key)\" of type \"\(String(describing: Value.self))\" does not exist")
        }
        self.setter = {
            UserDefaults.standard.set($0.rawValue, forKey: key)
        }
    }
    
    public init(_ key: String) where Value.RawValue == String {
        self.init(key: key)
    }
    
    public init(_ key: String) where Value.RawValue == Int {
        self.init(key: key)
    }
}

// MARK: Initializers with Key

extension Stored where Value: RawRepresentable {
    
    public init(_ key: StoredKey) where Value.RawValue == String {
        self.init(key: key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value.RawValue == Int {
        self.init(key: key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value.RawValue == String {
        self.init(value: wrappedValue, key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value.RawValue == Int {
        self.init(value: wrappedValue, key.rawValue)
    }
}
