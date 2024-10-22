//
//  UserDefaults + Publisher.swift
//  StoredWrapper
//
//  Created by Yevhen Biiak on 21.10.2024.
//

import Foundation
import Combine


public enum ObservationOption: Sendable {
    /// Whether a notification should be sent to the observer immediately, before the observer registration method even returns.
    case initial
    /// Whether separate notifications should be sent to the observer before and after each change, instead of a single notification after the change.
    case prior
}

public struct BaseChange {
    let kind: NSKeyValueChange
    let indexes: IndexSet?
    let isPrior: Bool
    let newValue: Any?
    let oldValue: Any?
    
    init(change: [NSKeyValueChangeKey: Any]) {
        self.kind = NSKeyValueChange(rawValue: change[.kindKey] as! UInt)!
        self.indexes = change[.indexesKey] as? IndexSet
        self.isPrior = change[.notificationIsPriorKey] as? Bool ?? false
        self.oldValue = change[.oldKey]
        self.newValue = change[.newKey]
    }
}

extension UserDefaults {
    public func publisher(key: String, options: Set<ObservationOption> = []) -> AnyPublisher<BaseChange, Never> {
        return DefaultsPublisher(suite: self, key: key, options: options).eraseToAnyPublisher()
    }
    public static func publisher(key: String, store: UserDefaults, options: Set<ObservationOption> = []) -> AnyPublisher<BaseChange, Never> {
        return DefaultsPublisher(suite: store, key: key, options: options).eraseToAnyPublisher()
    }
}


final class UserDefaultsKeyObservation: NSObject {
    typealias Callback = (BaseChange) -> Void
    
    private weak var object: UserDefaults?
    private let key: String
    private let callback: Callback
    private var isObserving = false
    
    init(object: UserDefaults, key: String, callback: @escaping Callback) {
        self.object = object
        self.key = key
        self.callback = callback
    }
    
    deinit {
        invalidate()
    }
    
    func start(options: Set<ObservationOption>) {
        object?.addObserver(self, forKeyPath: key, options: options.toNSKeyValueObservingOptions, context: nil)
        isObserving = true
    }
    
    func invalidate() {
        if isObserving {
            object?.removeObserver(self, forKeyPath: key, context: nil)
            isObserving = false
        }
        
        object = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let selfObject = self.object else {
            invalidate()
            return
        }
        
        guard
            selfObject == (object as? NSObject),
            let change
        else {
            return
        }
        
        // preventPropagationThreadDictionaryKey
        let key = "\(type(of: UserDefaultsKeyObservation.self))_threadUpdatingValuesFlag"
        let updatingValuesFlag = (Thread.current.threadDictionary[key] as? Bool) ?? false
        guard !updatingValuesFlag else {
            return
        }
        
        callback(BaseChange(change: change))
    }
}


/**
 Custom `Subscription` for `UserDefaults` key observation.
 */
final class DefaultsSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == BaseChange {
    private var subscriber: SubscriberType?
    private var observation: UserDefaultsKeyObservation?
    private let options: Set<ObservationOption>
    
    init(subscriber: SubscriberType, suite: UserDefaults, key: String, options: Set<ObservationOption>) {
        self.subscriber = subscriber
        self.options = options
        self.observation = .init(object: suite, key: key, callback: observationCallback)
    }
    
    func request(_ demand: Subscribers.Demand) {
        // Nothing as we send events only when they occur.
    }
    
    func cancel() {
        observation = nil
        subscriber = nil
    }
    
    func start() {
        observation?.start(options: options)
    }
    
    private func observationCallback(_ change: BaseChange) {
        _ = subscriber?.receive(change)
    }
}

/**
 Custom Publisher, which is using DefaultsSubscription.
 */
struct DefaultsPublisher: Publisher {
    typealias Output = BaseChange
    typealias Failure = Never
    
    private let suite: UserDefaults
    private let key: String
    private let options: Set<ObservationOption>
    
    init(suite: UserDefaults, key: String, options: Set<ObservationOption>) {
        self.suite = suite
        self.key = key
        self.options = options
    }
    
    func receive(subscriber: some Subscriber<Output, Failure>) {
        let subscription = DefaultsSubscription(
            subscriber: subscriber,
            suite: suite,
            key: key,
            options: options
        )
        
        subscriber.receive(subscription: subscription)
        subscription.start()
    }
}


extension Set<ObservationOption> {
    var toNSKeyValueObservingOptions: NSKeyValueObservingOptions {
        var options: NSKeyValueObservingOptions = [.old, .new]
        
        if contains(.initial) {
            options.insert(.initial)
        } else if contains(.prior) {
            options.insert(.prior)
        }
        
        return options
    }
}
