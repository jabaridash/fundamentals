// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: ["RxSwift"]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core", "Quick", "Nimble"]
        ),
    ]
)
