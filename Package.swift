// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LinkKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "LinkKit",
            targets: ["LinkKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/WindowSceneReader.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "LinkKit",
            dependencies: ["WindowSceneReader"]
        ),
        .testTarget(
            name: "LinkKitTests",
            dependencies: ["LinkKit"]
        )
    ]
)
