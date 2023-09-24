//
//  URL+DefaultApp+Other.swift
//  LinkKitTests
//
//  Created by David Walter on 10.07.23.
//

import XCTest

final class URL_DefaultApp_Other: XCTestCase {
    func testBooks() throws {
        let url = try XCTUnwrap(URL(string: "ibooks://"))
        
        XCTAssertEqual(url.app()?.type, .books)
    }
    
    func testCalendar() throws {
        let url = try XCTUnwrap(URL(string: "calshow://"))
        
        XCTAssertEqual(url.app()?.type, .calendar)
    }
    
    func testCalculator() throws {
        let url = try XCTUnwrap(URL(string: "calc://"))
        
        XCTAssertEqual(url.app()?.type, .calculator)
    }
    
    func testCamera() throws {
        let url = try XCTUnwrap(URL(string: "camera://"))
        
        XCTAssertEqual(url.app()?.type, .camera)
    }
    
    func testContacts() throws {
        let url = try XCTUnwrap(URL(string: "contact://"))
        
        XCTAssertEqual(url.app()?.type, .contacts)
    }
    
    func testFiles() throws {
        func testNotes() throws {
            let url = try XCTUnwrap(URL(string: "shareddocuments://"))
            
            XCTAssertEqual(url.app()?.type, .files)
        }
    }
    
    func testFreeform() throws {
        func testNotes() throws {
            let url = try XCTUnwrap(URL(string: "freeform://"))
            
            XCTAssertEqual(url.app()?.type, .freeform)
        }
    }
    
    func testNotes() throws {
        let url = try XCTUnwrap(URL(string: "mobilenotes://"))
        
        XCTAssertEqual(url.app()?.type, .notes)
    }
    
    func testReminders() throws {
        let url = try XCTUnwrap(URL(string: "x-apple-reminder://"))
        
        XCTAssertEqual(url.app()?.type, .reminders)
    }
    
    func testStocks() throws {
        let url = try XCTUnwrap(URL(string: "stocks://"))
        
        XCTAssertEqual(url.app()?.type, .stocks)
    }
}
