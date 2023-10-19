//
//  URLQueryDecoder.swift
//  LinkKit
//
//  Created by David Walter on 07.07.23.
//

import Foundation

public final class URLQueryDecoder {
    init() {
    }
    
    public func decode<T>(_ type: T.Type, from string: String) throws -> T where T: Decodable {
        var components: [String: String] = [:]
        for component in string.split(separator: "&") {
            let keyValue = component.split(separator: "=", maxSplits: 1).map { String($0) }
            guard let key = keyValue[safe: 0] else { continue }
            components[key] = keyValue[safe: 1]?.replacingOccurrences(of: "+", with: " ").removingPercentEncoding
        }
        return try T(from: _URLQueryDecoder(referencing: components))
    }
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        guard let string = String(data: data, encoding: .utf8) else {
            throw URLQueryDecoder.Error.dataCorrupted
        }
        return try decode(type, from: string)
    }
}

extension URLQueryDecoder {
    enum Error: Swift.Error {
        case dataCorrupted
        case unsupported(_ message: String)
    }
}

// swiftlint:disable:next type_name
final class _URLQueryDecoder: Decoder {
    var storage: URLQueryStorage
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    
    init(referencing container: [String: String], at codingPath: [CodingKey] = []) {
        self.storage = URLQueryStorage(container: container)
        self.codingPath = codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        let container = URLQueryKeyedDecodingContainer<Key>(referencing: self, wrapping: storage.container)
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw URLQueryDecoder.Error.unsupported("Unkeyed Containers are not supported.")
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        URLQuerySingleValueDecodingContainer(referencing: self)
    }
}
