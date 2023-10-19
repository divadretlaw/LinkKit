//
//  URLQueryEncoder.swift
//  LinkKit
//
//  Created by David Walter on 07.07.23.
//

import Foundation

public final class URLQueryEncoder {
    public var nestedValueStrategy: NestedValueStrategy = .error

    public enum NestedValueStrategy {
        case error
        case flatten
    }
    
    public var userInfo: [CodingUserInfoKey: Any] = [:]
    
    private var options: Options {
        Options(nestedValueStrategy: nestedValueStrategy,
                userInfo: userInfo)
    }

    struct Options {
        let nestedValueStrategy: NestedValueStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
    
    public init() {
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> String {
        let encoder = _URLQueryEncoder(with: options)
        try value.encode(to: encoder)
        return encoder.storage.container.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }
        .joined(separator: "&")
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let encoder = _URLQueryEncoder(with: options)
        try value.encode(to: encoder)
        return encoder.storage.container.map { key, value in
            URLQueryItem(name: key, value: value)
        }
    }
}

extension URLQueryEncoder {
    enum Error: Swift.Error {
        case unsupported(_ message: String)
    }
}

// swiftlint:disable:next type_name
final class _URLQueryEncoder: Encoder {
    var codingPath: [CodingKey]
    var storage: URLQueryStorage
    var options: URLQueryEncoder.Options
    
    init(at codingPath: [CodingKey] = [], with options: URLQueryEncoder.Options) {
        self.codingPath = codingPath
        self.storage = URLQueryStorage(container: [:])
        self.options = options
    }
    
    var userInfo: [CodingUserInfoKey: Any] {
        options.userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        let container = URLQueryKeyedEncodingContainer<Key>(referencing: self)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("URLQueryEncoder does not support unkeyed containers.")
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        URLQuerySingleValueEncodingContainer(referencing: self)
    }
}
