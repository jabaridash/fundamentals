//
//  String+Extension.swift
//  Fundamentals
//
//  Created by jabari on 11/6/20.
//

import Foundation

internal extension Sequence where Element: Equatable {
    /// Counts the amount of times an element appears in the sequence.
    /// - Parameter element: The specified element to count.
    /// - Returns: The number of times the specified element occures.
    func occurences(of element: Element) -> Int {
        return count { $0 == element }
    }
}

internal extension Sequence {
    /// Counts the amount of times an element matches a given predicate.
    /// - Parameter match: Predicate that determines whether or not an element matches.
    /// - Returns: The number of times the specified predicate returned true.
    func count(where match: (Element) -> Bool) -> Int {
        return self.reduce(0) { $0 + (match($1) ? 1 : 0) }
    }
}
