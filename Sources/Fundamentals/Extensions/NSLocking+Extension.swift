//
//  NSLocking.swift
//  Fundamentals
//
//  Created by jabari on 11/9/20.
//

import Foundation

extension NSLocking {
    func sync(_ work: @escaping () -> Void) {
        lock()
        defer { unlock() }
        work()
    }
}
