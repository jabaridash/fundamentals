//
//  Dictionary+Extension.swift
//  Core
//
//  Created by jabari on 11/3/20.
//

// MARK: - Functions for merging dictionaries

internal extension Dictionary {
    /// Creates a new `Dictionary` that represents the combination of this `Dictionary` and the supplied`
    /// `Dictionary`. Entries in this `Dictionary` will be overriden by entries from the supplied `Dictionary`
    /// if they have the same key.
    /// - Parameter dictionary: Specified `Dictionary` to merge / override entries from.
    /// - Returns: A new `Dictionary` that contains entries from both `Dictionary` objects.
    func merged(with dictionary: [Key: Value]) -> [Key: Value] {
        var copy = self
        
        copy.merge(with: dictionary)
        
        return copy
    }
    
    /// Combines this `Dictionary` with a supplied `Dictionary`. Entries in this `Dictionary` will
    /// be overriden by entries from the supplied `Dictionary` if they have the same key.
    /// - Parameter dictionary: Specified `Dictionary` to merge / override entries from.
    mutating func merge(with dictionary: [Key: Value]) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }
}
