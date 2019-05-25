// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ansiSlide",
    dependencies: [
        .package(url: "https://github.com/pakLebah/ANSITerminal", from: "0.0.3"),
    ],
    targets: [
        .target(
            name: "ansiSlide",
            dependencies: ["ANSITerminal"],
            path: "Sources"),
    ]
)
