// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "swift-chat",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SwiftChat",
            targets: ["SwiftChat"]),
        .library(
            name: "UnionChat",
            targets: ["UnionChatWrapper"])
    ],
    targets: [
        .target(
            name: "SwiftChat",
            dependencies: ["UnionChatBinary"],
            path: "Sources/SwiftChat"
        ),
        .target(
            name: "UnionChatWrapper",
            dependencies: ["UnionChatBinary"],
            path: "Sources/UnionChatWrapper"
        ),
        .binaryTarget(
            name: "UnionChatBinary",
            url: "https://github.com/unionst/swift-chat/releases/download/1.0.7/UnionChat.xcframework.zip",
            checksum: "a3a90fb13eb32c11d7d5b226d055e01dabed9e6d08069e75f50f07c4bcd470d1"
        )
    ]
)
