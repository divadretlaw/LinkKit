//
//  String+Extensions.swift
//  LinkKit
//
//  Created by David Walter on 11.07.23.
//

import Foundation

extension String {
    func removingCharacters(in set: CharacterSet) -> String {
        self.components(separatedBy: set).joined()
    }
}
