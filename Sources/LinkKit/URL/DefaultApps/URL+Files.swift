//
//  URL+Files.swift
//  LinkKit
//
//  Created by David Walter on 12.07.23.
//

import Foundation

extension URL {
    // MARK: - App
    
    public struct Files: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
        }
        
        // MARK: App Link
        
        public var type: AppLinkType { .contacts }
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["shareddocuments", "smb"]
        }
    }
}