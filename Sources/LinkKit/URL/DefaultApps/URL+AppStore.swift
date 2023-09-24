//
//  URL+AppStore.swift
//  LinkKit
//
//  Created by David Walter on 09.07.23.
//

import Foundation
#if canImport(StoreKit)
import StoreKit
#endif

extension URL {
    /// Creates a App Store URL instance from the provided data.
    ///
    /// - Parameters:
    ///   - appleMaps: The App Store Parameters. See ``AppStoreParameters``.
    ///   - preferUniversalLink: Wheter to create the URL using the universal link or url scheme. Defaults to `false`.
    public static func appStore(parameters: AppStoreParameter, preferUniversalLink: Bool = false) -> URL {
        if preferUniversalLink {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://apps.apple.com/app/apple-store/\(parameters.description)")!
        } else {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "itms-apps://apps.apple.com/app/apple-store/\(parameters.description)")!
        }
    }
}

extension URL {
    // MARK: App
    
    public struct AppStore: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let parameters: AppStoreParameter
        
        public init?(url: URL) {
            guard let parameters = AppStoreParameter(url: url) else { return nil }
            self.url = url
            self.parameters = parameters
        }
        
        public init(parameters: AppStoreParameter) {
            self.url = URL.appStore(parameters: parameters)
            self.parameters = parameters
        }
        
        // MARK: App Link
        
        public var type: AppLinkType { .appStore }
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["itms-apps", "itms-appss", "macappstore", "macappstores"]
        }
        
        public static var hosts: [String]? {
            ["apps.apple.com", "itunes.apple.com"]
        }
        
        public static func check(against url: URL) -> Bool {
            AppStoreParameter(url: url) != nil
        }
    }
    
    // MARK: Parameter
    
    /// App Store URL Parameters
    ///
    /// See [App Store Links](https://developer.apple.com/library/archive/qa/qa1629/_index.html) for more details.
    public struct AppStoreParameter: Equatable, Hashable, Codable, CustomStringConvertible {
        public var id: Int
        
        public init?(url: URL) {
            guard url.scheme(isAny: AppStore.schemes + ["https", "http"]) else { return nil }
            guard let hosts = AppStore.hosts, url.host(isAny: hosts) else { return nil }
            guard url.lastPathComponent.hasPrefix("id") else { return nil }
            guard let id = Int(url.lastPathComponent.dropFirst(2)) else { return nil }
            self.id = id
        }
        
        public init(id: Int) {
            self.id = id
        }
        
        // MARK: CustomStringConvertible
        
        public var description: String {
            "id\(id)"
        }
    }
}
