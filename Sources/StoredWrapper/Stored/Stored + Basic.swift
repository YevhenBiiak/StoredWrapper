//
//  Stored + Basic.swift
//  Playground
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation

// MARK: Initializers with WrappedValue

extension Stored {
    
    private init(value: Value, _ key: String) {
        self.key = key
        self.getter = {
            if let value = UserDefaults.standard.object(forKey: key) as? Value {
                return value
            }
            fatalError("Value for key \"\(key)\" of type \"\(String(describing: Value.self))\" does not exist")
        }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
        
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    public init(wrappedValue: Value, _ key: String) where Value == String {
        self.init(value: wrappedValue, key)
    }
    
    public init(wrappedValue: Value, _ key: String) where Value == Int {
        self.init(value: wrappedValue, key)
    }
    
    public init(wrappedValue: Value, _ key: String) where Value == Data {
        self.init(value: wrappedValue, key)
    }
    
    public init(wrappedValue: Value, _ key: String) where Value == Double {
        self.init(value: wrappedValue, key)
    }
    
    public init(wrappedValue: Value, _ key: String) where Value == Bool {
        self.init(value: wrappedValue, key)
    }
    
    public init(wrappedValue: Value, _ key: String) where Value == URL {
        self.init(value: wrappedValue, key)
    }
}

// MARK: Initializers without WrappedValue (Force!)

extension Stored {
    
    private init(key: String) {
        self.key = key
        self.getter = {
            if let value = UserDefaults.standard.object(forKey: key) as? Value {
                return value
            }
            fatalError("Value for key \"\(key)\" of type \"\(String(describing: Value.self))\" does not exist")
        }
        self.setter = {
            UserDefaults.standard.set($0, forKey: key)
        }
    }
    
    public init(_ key: String) where Value == String {
        self.init(key: key)
    }
    
    public init(_ key: String) where Value == Int {
        self.init(key: key)
    }
    
    public init(_ key: String) where Value == Data {
        self.init(key: key)
    }
    
    public init(_ key: String) where Value == Double {
        self.init(key: key)
    }
    
    public init(_ key: String) where Value == Bool {
        self.init(key: key)
    }
    
    public init(_ key: String) where Value == URL {
        self.init(key: key)
    }
}

// MARK: Initializers with Key

extension Stored {
    
    public init(_ key: StoredKey) where Value == String {
        self.init(key: key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Int {
        self.init(key: key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Bool {
        self.init(key: key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Double {
        self.init(key: key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Data {
        self.init(key: key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == URL {
        self.init(key: key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value == String {
        self.init(value: wrappedValue, key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value == Int {
        self.init(value: wrappedValue, key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value == Bool {
        self.init(value: wrappedValue, key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value == Double {
        self.init(value: wrappedValue, key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value == Data {
        self.init(value: wrappedValue, key.rawValue)
    }
    
    public init(wrappedValue: Value, _ key: StoredKey) where Value == URL {
        self.init(value: wrappedValue, key.rawValue)
    }
}
