//
//  Stored + Enum Key.swift
//  Playground
//
//  Created by Yevhen Biiak on 12.08.2023.
//

import Foundation

public struct StoredKey: RawRepresentable {
    public var rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
