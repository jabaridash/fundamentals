//
//  SampleApplicationApp.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Fundamentals
import SwiftUI

@main
struct SampleApplicationApp: App {
    // https://peterfriese.dev/ultimate-guide-to-swiftui2-application-lifecycle/
    init() {
        Self.registerServices()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(for: GitHubService.self)
        }
    }
}
