//
//  Stored.swift
//  Playground
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation

@propertyWrapper
public struct Stored<Value> {
    
    internal let key: String
    internal let getter: () -> Value
    internal let setter: (Value) -> Void
    
    public var wrappedValue: Value {
        get { getter() }
        set { setter(newValue) }
    }
}

extension Stored: CustomStringConvertible where Value == Void {
    
    public init(_ key: String) {
        self.key = key
        self.getter = {}
        self.setter = {_ in}
    }
    
    public init(_ key: StoredKey) {
        self.init(key.rawValue)
    }
    
    public var isExists: Bool {
        UserDefaults.standard.object(forKey: key) != nil
    }
    
    public var description: String {
        let storedValue = UserDefaults.standard.object(forKey: key)
        if let storedValue {
            return String(describing: storedValue)
        } else {
            return String(describing: storedValue)
        }
    }
    
    @discardableResult
    public func remove() -> String {
        let description = description
        UserDefaults.standard.removeObject(forKey: key)
        return description
    }
    
    public static func removeAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
