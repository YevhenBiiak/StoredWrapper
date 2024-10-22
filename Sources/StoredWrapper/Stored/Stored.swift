//
//  Stored.swift
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import SwiftUI
import Combine


final private class StoredObject<Value>: NSObject, ObservableObject {
    
    internal let key: String
    internal let getter: () -> Value
    internal let setter: (Value) -> Void
    internal let store: UserDefaults
    
    internal var value: Value { getter() }
    
    private var cancellable: AnyCancellable?
    
    internal init(key: String, value: Value?, store: UserDefaults, getter: @escaping () -> Value, setter: @escaping (Value) -> Void) where Value: Codable {
        self.key = key
        self.getter = getter
        self.setter = setter
        self.store = store
        super.init()
        
        if store.object(forKey: key) == nil {
            if let value {
                setter(value)
            }
        }
        
        self.objectWillChange.send()
        
        cancellable = store.publisher(key: key).sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    internal var isExists: Bool {
        store.object(forKey: key) != nil
    }
    
    internal func remove() {
        store.removeObject(forKey: key)
    }
    
    internal func set(value: Value) {
        setter(value)
    }
}

@propertyWrapper
public struct Stored<Value>: DynamicProperty {
    
    @ObservedObject private var object: StoredObject<Value>
    
    private var cancellable: AnyCancellable?
    
    public var wrappedValue: Value {
        get {
            object.value
        }
        nonmutating set {
            object.set(value: newValue)
        }
    }
    
    public var projectedValue: Binding<Value> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }
    }
    
    public var publisher: AnyPublisher<Value, Never> {
        get {
            object.store.publisher(key: object.key).compactMap {
                $0.newValue as? Value
            }.eraseToAnyPublisher()
        }
    }
    
    internal init(key: String, value: Value?, store: UserDefaults, getter: @escaping () -> Value, setter: @escaping (Value) -> Void) where Value: Codable {
        self.object = StoredObject(key: key, value: value, store: store, getter: getter, setter: setter)
    }
    
    public var isExists: Bool {
        object.isExists
    }
    
    public func remove() {
        object.remove()
    }
    
    public func set(value: Value) where Value: Codable {
        object.set(value: value)
    }
}

extension Stored where Value == Void {
    public static func removeAll(store: UserDefaults = .standard) {
        store.dictionaryRepresentation().map(\.key).forEach(store.removeObject) 
    }
}
