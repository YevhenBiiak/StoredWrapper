//
//  Stored + Optional.swift
//  Playground
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation

extension Stored where Value: ExpressibleByNilLiteral {
        
    public init(_ key: String) where Value == Int? {
        self.key = key
        self.getter = { UserDefaults.standard.object(forKey: key) as? Int }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
    }
    
    public init(_ key: String) where Value == String? {
        self.key = key
        self.getter = { UserDefaults.standard.object(forKey: key) as? String }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
    }
    
    public init(_ key: String) where Value == Double? {
        self.key = key
        self.getter = { UserDefaults.standard.object(forKey: key) as? Double }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
    }
    
    public init(_ key: String) where Value == Bool? {
        self.key = key
        self.getter = { UserDefaults.standard.object(forKey: key) as? Bool }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
    }
    
    public init(_ key: String) where Value == URL? {
        self.key = key
        self.getter = { UserDefaults.standard.object(forKey: key) as? URL }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
    }
    
    public init(_ key: String) where Value == Data? {
        self.key = key
        self.getter = { UserDefaults.standard.object(forKey: key) as? Data }
        self.setter = { UserDefaults.standard.set($0, forKey: key) }
    }
}

extension Stored where Value: ExpressibleByNilLiteral {
    
    init<R>(_ key: String) where Value == R?, R : RawRepresentable, R.RawValue == Int {
        self.key = key
        self.getter = {
            if let rawValue = UserDefaults.standard.object(forKey: key) as? R.RawValue {
                return R(rawValue: rawValue)
            }
            return nil
        }
        self.setter = {
            UserDefaults.standard.set($0?.rawValue, forKey: key)
            
        }
    }

    init<R>(_ key: String) where Value == R?, R : RawRepresentable, R.RawValue == String {
        self.key = key
        self.getter = {
            if let rawValue = UserDefaults.standard.object(forKey: key) as? R.RawValue {
                return R(rawValue: rawValue)
            }
            return nil
        }
        self.setter = {
            UserDefaults.standard.set($0?.rawValue, forKey: key)
            
        }
    }
}

// MARK: Initializers with Key

extension Stored where Value: ExpressibleByNilLiteral {
    
    public init(_ key: StoredKey) where Value == Int? {
        self.init(key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == String? {
        self.init(key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Bool? {
        self.init(key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Double? {
        self.init(key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == Data? {
        self.init(key.rawValue)
    }
    
    public init(_ key: StoredKey) where Value == URL? {
        self.init(key.rawValue)
    }
    
    public init<R>(_ key: StoredKey) where Value == R?, R : RawRepresentable, R.RawValue == Int {
        self.init(key.rawValue)
    }
    
    public init<R>(_ key: StoredKey) where Value == R?, R : RawRepresentable, R.RawValue == String {
        self.init(key.rawValue)
    }
}
