//
//  URL+AppLink.swift
//  LinkKit
//
//  Created by David Walter on 09.07.23.
//

import Foundation

public protocol AppLink {
    var type: AppLinkType { get }
    
    init?(url: URL)
    
    /// Checks if the app link represents a default app.
    static var isDefaultApp: Bool { get }
    /// Checks if the app link represents a third-party app.
    static var isThirdPartyApp: Bool { get }
    
    /// The known schemes for this app
    static var schemes: [String] { get }
    /// The known url hosts for this app
    static var hosts: [String]? { get }
    
    /// Check if the given url represents this app link
    /// - Parameter url: The url to check against
    /// - Returns: `true` if the url represents this app link
    static func check(against url: URL) -> Bool
}

// Defaults
public extension AppLink {
    static var isThirdPartyApp: Bool { !isDefaultApp }
    static var hosts: [String]? { nil }
    
    static func check(against url: URL) -> Bool {
        url.scheme(isAny: schemes)
    }
}

extension AppLink {
    static var canBeUniversalLink: Bool {
        hosts != nil
    }
}

/// The known app links
public enum AppLinkType: CaseIterable, Equatable, Hashable, Codable {
    /// Apple Maps
    case appleMaps
    /// App Store
    case appStore
    /// Apple Books
    case books
    /// Calculator
    case calculator
    /// Calendar
    case calendar
    /// Camera
    case camera
    /// Clock
    case clock
    /// Contacts
    case contacts
    /// FaceTime
    case faceTime
    /// Files
    case files
    /// Freeform
    case freeform
    /// Health
    case health
    /// Mail
    case mail
    /// Notes
    case notes
    /// Phone
    case phone
    /// Reminders
    case reminders
    /// Settings
    case settings
    /// Messages
    case sms
    /// Stocks
    case stocks
    /// WhatsApp
    case whatsApp
    /// YouTube
    case youTube
    
    var type: AppLink.Type {
        switch self {
        case .appleMaps:
            return URL.AppleMaps.self
        case .appStore:
            return URL.AppStore.self
        case .books:
            return URL.Books.self
        case .calculator:
            return URL.Calculator.self
        case .calendar:
            return URL.Calendar.self
        case .camera:
            return URL.Camera.self
        case .clock:
            return URL.Clock.self
        case .contacts:
            return URL.Contacts.self
        case .faceTime:
            return URL.FaceTime.self
        case .files:
            return URL.Files.self
        case .freeform:
            return URL.Freeform.self
        case .health:
            return URL.Health.self
        case .mail:
            return URL.Mail.self
        case .notes:
            return URL.Notes.self
        case .phone:
            return URL.Phone.self
        case .reminders:
            return URL.Reminders.self
        case .settings:
            return URL.Settings.self
        case .sms:
            return URL.SMS.self
        case .stocks:
            return URL.Stocks.self
        case .whatsApp:
            return URL.WhatsApp.self
        case .youTube:
            return URL.YouTube.self
        }
    }
    
    /// Checks if the app link represents a default app.
    public var isDefaultApp: Bool {
        self.type.isDefaultApp
    }
    
    /// Checks if the app link represents a third party app.
    public var isThirdPartyApp: Bool {
        self.type.isThirdPartyApp
    }
    
    static var allUniversalLinkCases: [AppLinkType] {
        allCases.filter { $0.type.canBeUniversalLink }
    }
}

extension URL {
    /// Evaluates the URL if it represents any known app link.
    ///
    /// - Returns: The app or `nil` if its not a known app.
    ///
    /// See ``AppLinkType``s for list of supported apps.
    public func app() -> (any AppLink)? {
        if ["https", "http"].contains(scheme?.lowercased()) {
            for appType in AppLinkType.allUniversalLinkCases {
                if let value = appType.type.init(url: self) {
                    return value
                }
            }
        } else {
            for appType in AppLinkType.allCases {
                if let value = appType.type.init(url: self) {
                    return value
                }
            }
        }
        
        return nil
    }
}
