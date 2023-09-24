//
//  URL+ThirdParty+YouTube.swift
//  LinkKitTests
//
//  Created by David Walter on 10.07.23.
//

import XCTest
@testable import LinkKit

final class URL_ThirdPartyApps_YouTube: XCTestCase {
    func testWatchUniversalLink() throws {
        let url = try XCTUnwrap(URL(string: "https://www.youtube.com/watch?v=AuBXeF5acqE"))
        let app = try XCTUnwrap(url.app() as? URL.YouTube)
        
        XCTAssertEqual(app.videoIdentifier, "AuBXeF5acqE")
    }
    
    func testVUniversalLink() throws {
        let url = try XCTUnwrap(URL(string: "https://youtube.com/v/AuBXeF5acqE"))
        let app = try XCTUnwrap(url.app() as? URL.YouTube)
        
        XCTAssertEqual(app.videoIdentifier, "AuBXeF5acqE")
    }
    
    func testURLScheme() throws {
        let url = try XCTUnwrap(URL(string: "youtube://AuBXeF5acqE"))
        let app = try XCTUnwrap(url.app() as? URL.YouTube)
        
        XCTAssertEqual(app.videoIdentifier, "AuBXeF5acqE")
    }
}
