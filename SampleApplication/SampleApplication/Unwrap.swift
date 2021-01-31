//
//  Unwrap.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import SwiftUI

// MARK: - Unwrap

// https://www.swiftbysundell.com/tips/optional-swiftui-views/
struct Unwrap<Value, Content: View>: View {
    private let value: Value?
    private let contentProvider: (Value) -> Content

    init(_ value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.contentProvider = content
    }

    var body: some View {
        value.map(contentProvider)
    }
}
