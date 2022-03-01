// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIPausableAnimation",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "SwiftUIPausableAnimation",
            targets: ["SwiftUIPausableAnimation"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftUIPausableAnimation",
            dependencies: []),
        .testTarget(
            name: "SwiftUIPausableAnimationTests",
            dependencies: ["SwiftUIPausableAnimation"]),
    ]
)
