//
//  RandomArray.swift
//  PokéMatch
//
//  Created by Allen Boynton on 5/29/17.
//  Copyright © 2017 Allen Boynton. All rights reserved.
//

import Foundation

extension Array {
    //Randomizes the order of the array elements
    mutating func shuffle() {
        for _ in 1...self.count {
            self.sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

// Extension to filter numbers out of string
extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}
