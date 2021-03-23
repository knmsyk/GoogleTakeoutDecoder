// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GoogleTakeoutDecoder",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7)
    ],
    products: [
        .library(
            name: "GoogleTakeoutDecoder",
            targets: ["GoogleTakeoutDecoder"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.12.0"),
    ],
    targets: [
        .target(
            name: "GoogleTakeoutDecoder",
            dependencies: []),
        .testTarget(
            name: "GoogleTakeoutDecoderTests",
            dependencies: ["GoogleTakeoutDecoder"]),
    ]
)
