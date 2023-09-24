//
//  URL+Settings.swift
//  LinkKit
//
//  Created by David Walter on 12.07.23.
//

import Foundation

extension URL {
    public static func settings(root: URL.Settings.Root? = nil, path: String? = nil) -> URL {
        fatalError("Not implemented")
    }
}

extension URL {
    // MARK: - App
    
    public struct Settings: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let parameter: SettingsParameter
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            
            if !components.path.isEmpty {
                do {
                    self.parameter = try URLQueryDecoder().decode(SettingsParameter.self, from: components.path)
                } catch {
                    return nil
                }
            } else {
                self.parameter = SettingsParameter()
            }
        }
        
        // MARK: App Link
        
        public var type: AppLinkType { .settings }
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["app-prefs"]
        }
    }
    
    // MARK: Parameter
    
    public struct SettingsParameter: Equatable, Hashable, Codable {
        public var root: URL.Settings.Root?
        public var path: String?
        
        public init(root: URL.Settings.Root? = nil, path: String? = nil) {
            self.root = root
            self.path = path
        }
        
        // MARK: Codable
        
        enum CodingKeys: CodingKey {
            case root
            case path
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.root = try container.decodeIfPresent(URL.Settings.Root.self, forKey: .root)
            self.path = try container.decodeIfPresent(String.self, forKey: .path)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.root, forKey: .root)
            try container.encodeIfPresent(self.path, forKey: .path)
        }
    }
}

// MARK: - Subtypes

extension URL.Settings {
    public enum Root: String, Equatable, Hashable, Codable {
        case general = "General"
        
        case accessiblity = "ACCESSIBILITY"
        case airPlaneMode = "AIRPLANE_MODE"
        case appleId = "APPLE_ACCOUNT"
        case appStore = "STORE"
        case battery = "BATTERY_USAGE"
        case bluetooth = "Bluetooth"
        case books = "IBOOKS"
        case brightness = "Brightness"
        case calendar = "CALENDAR"
        case camera = "CAMERA"
        case cellular = "MOBILE_DATA_SETTINGS_ID"
        case compass = "COMPASS"
        case contacts = "CONTACTS"
        case display = "DISPLAY"
        case dns = "VPN/DNS"
        case faceTime = "FACETIME"
        case health = "HEALTH"
        case iCloud = "CASTLE"
        case mail = "MAIL"
        case maps = "MAPS"
        case measure = "MEASURE"
        case messages = "MESSAGES"
        case music = "MUSIC"
        case news = "NEWS"
        case notes = "NOTES"
        case notifications = "NOTIFICATIONS_ID"
        case passcode = "PASSCODE"
        case passwords = "PASSWORDS"
        case personalHotspot = "INTERNET_TETHERING"
        case phone = "Phone"
        case photos = "Photos"
        case privacy = "PRIVACY"
        case reminders = "REMINDERS"
        case safari = "SAFARI"
        case siri = "SIRI"
        case shortcuts = "SHORTCUTS"
        case tv = "TVAPP" // swiftlint:disable:this identifier_name
        case voiceMemos = "VOICE_MEMOS"
        case vpn = "VPN"
        case wallet = "PASSBOOK"
        case wallpaper = "Wallpaper"
        case wifi = "WIFI"
    }
}
