//
//  Logger.swift
//  LinkKit
//
//  Created by David Walter on 19.10.23.
//

import Foundation
import OSLog

extension Logger {
    static var url = Logger(subsystem: "at.davidwalter.LinkKit", category: "URL")
    static var openURL = Logger(subsystem: "at.davidwalter.LinkKit", category: "OpenURL")
    static var safari = Logger(subsystem: "at.davidwalter.LinkKit", category: "Safari")
}
