// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Fundamentals",
    products: [
        .library(name: "Fundamentals", targets: ["Fundamentals"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "1.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.0"),
    ],
    targets: [
        .target(name: "Fundamentals", dependencies: []),
        .testTarget(name: "FundamentalsTests", dependencies: ["Fundamentals", "Quick", "Nimble"]),
    ]
)
