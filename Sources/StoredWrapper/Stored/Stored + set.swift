//
//  File.swift
//  
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation

public protocol IntegerProtocol {}
public protocol DoubleProtocol {}
public protocol StringProtocol {}
public protocol BoolProtocol {}
public protocol DataProtocol {}
public protocol URLProtocol {}

extension Int:    IntegerProtocol {}
extension Double: DoubleProtocol {}
extension String: StringProtocol {}
extension Bool:   BoolProtocol {}
extension Data:   DataProtocol {}
extension URL:    URLProtocol {}

extension Stored {
    
    public func set(value: Value) where Value: IntegerProtocol {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func set(value: Value) where Value: DoubleProtocol {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func set(value: Value) where Value: StringProtocol {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func set(value: Value) where Value: BoolProtocol {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func set(value: Value) where Value: DataProtocol {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func set(value: Value) where Value == URLProtocol {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func set(value: Value) where Value: RawRepresentable {
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
}
