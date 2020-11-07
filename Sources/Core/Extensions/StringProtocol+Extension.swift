//
//  String+Extension.swift
//  Core
//
//  Created by jabari on 11/6/20.
//

import Foundation

public extension StringProtocol {
    func occurences(of character: Character) -> Int {
        return count { $0 == character }
    }
    
    func count(where match: (Character) -> Bool) -> Int {
        return self.reduce(0) { $0 + (match($1) ? 1 : 0) }
    }
}
