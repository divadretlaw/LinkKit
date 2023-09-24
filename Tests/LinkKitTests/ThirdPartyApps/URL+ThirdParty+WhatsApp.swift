//
//  URL+ThirdParty+WhatsApp.swift
//  LinkKitTests
//
//  Created by David Walter on 11.07.23.
//

import XCTest
@testable import LinkKit

final class URL_ThirdParty_WhatsApp: XCTestCase {
    func testInit() throws {
        let url = URL.whatsApp(number: "+001-(555)1234567")
        let app = try XCTUnwrap(url.app() as? URL.WhatsApp)
        
        XCTAssertEqual(app.number, "15551234567")
    }
    
    func testUniversalLink() throws {
        let url = try XCTUnwrap(URL(string: "https://wa.me/15551234567?text=I'm%20interested%20in%20your%20car%20for%20sale"))
        let app = try XCTUnwrap(url.app() as? URL.WhatsApp)
        
        XCTAssertEqual(app.number, "15551234567")
        XCTAssertEqual(app.parameters.text, "I'm interested in your car for sale")
    }
    
    func testUniversalLinkNoNumber() throws {
        let url = try XCTUnwrap(URL(string: "https://wa.me/?text=I'm%20inquiring%20about%20the%20apartment%20listing"))
        let app = try XCTUnwrap(url.app() as? URL.WhatsApp)
        
        XCTAssertNil(app.number)
        XCTAssertEqual(app.parameters.text, "I'm inquiring about the apartment listing")
    }
    
    func testURLScheme() throws {
        let url = try XCTUnwrap(URL(string: "whatsapp://15551234567?text=I'm%20interested%20in%20your%20car%20for%20sale"))
        let app = try XCTUnwrap(url.app() as? URL.WhatsApp)
        
        XCTAssertEqual(app.number, "15551234567")
        XCTAssertEqual(app.parameters.text, "I'm interested in your car for sale")
    }
}
