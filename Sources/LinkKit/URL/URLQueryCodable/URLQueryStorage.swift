//
//  URLQueryStorage.swift
//  LinkKit
//
//  Created by David Walter on 07.07.23.
//

import Foundation

struct URLQueryStorage {
    private var stack: [String]
    var container: [String: String]
    
    init(container: [String: String]) {
        self.container = container
        self.stack = []
    }
    
    var isEmpty: Bool {
        stack.isEmpty
    }
    
    mutating func push(_ value: String) {
        stack.append(value)
    }
    
    mutating func pop() -> String {
        stack.removeLast()
    }
}
