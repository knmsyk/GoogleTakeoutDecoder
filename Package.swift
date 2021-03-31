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
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", .upToNextMajor(from: "0.12.0")),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0"))
    ],
    targets: [
        .target(
            name: "GoogleTakeoutDecoder",
            dependencies: ["XMLCoder", "ZIPFoundation"]),
        .testTarget(
            name: "GoogleTakeoutDecoderTests",
            dependencies: ["GoogleTakeoutDecoder"],
            resources: [
                .process("Data/takeout.zip"),
                .process("Data/feed.atom")
            ]
        )
    ]
)
