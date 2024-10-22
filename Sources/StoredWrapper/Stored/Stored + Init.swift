//
//  Stored + Init.swift
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation


extension Stored {
    
    ///
    /// With default value
    /// @Stored("key") var value: Int = 0
    /// @Stored("key") var value: Model? = 0
    ///
    public init(wrappedValue: Value, _ key: String, store: UserDefaults = .standard) where Value: Codable {
        self.init(key: key, value: wrappedValue, store: store, getter: {
            if let data = store.data(forKey: key) {
                do {
                    return try JSONDecoder().decode(Value.self, from: data)
                } catch {
                    fatalError("⚠️ Error while decoding \"\(String(describing: Value.self))\" for key \"\(key)\": \(error)")
                }
            }
            if let nilValue = Optional<Any>(nilLiteral: ()) as? Value {
                return nilValue
            } else if let emptyDictionary = NSDictionary() as? Value {
                return emptyDictionary
            } else if let emptySet = NSSet() as? Value {
                return emptySet
            } else if let emptyArray = NSArray() as? Value {
                return emptyArray
            } else {
                fatalError("Value for key \"\(key)\" of type \"\(String(describing: Value.self))\" does not exist")
            }
        }, setter: {
            do {
                let data = try JSONEncoder().encode($0)
                store.set(data, forKey: key)
            } catch {
                print("⚠️ Error while encoding \"\(String(describing: Value.self))\" for key \"\(key)\": \(error)")
            }
        })
    }
    
    ///
    /// Without default value
    /// @Stored("key") var value: Int
    /// @Stored("key") var value: Model?
    ///
    public init(_ key: String, store: UserDefaults = .standard) where Value: Codable {
        self.init(key: key, value: nil, store: store, getter: {
            if let data = store.data(forKey: key) {
                do {
                    return try JSONDecoder().decode(Value.self, from: data)
                } catch {
                    fatalError("⚠️ Error while decoding \"\(String(describing: Value.self))\" for key \"\(key)\": \(error)")
                }
            }
            if let nilValue = Optional<Any>(nilLiteral: ()) as? Value {
                return nilValue
            } else if let emptyDictionary = NSDictionary() as? Value {
                return emptyDictionary
            } else if let emptySet = NSSet() as? Value {
                return emptySet
            } else if let emptyArray = NSArray() as? Value {
                return emptyArray
            } else {
                fatalError("Value for key \"\(key)\" of type \"\(String(describing: Value.self))\" does not exist")
            }
        }, setter: {
            do {
                let data = try JSONEncoder().encode($0)
                store.set(data, forKey: key)
            } catch {
                print("⚠️ Error while encoding \"\(String(describing: Value.self))\" for key \"\(key)\": \(error)")
            }
        })
    }
}
