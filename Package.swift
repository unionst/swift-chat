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
            url: "https://github.com/unionst/swift-chat/releases/download/1.3.0/UnionChat.xcframework.zip",
            checksum: "edc4be5d6f6ad96f3271c7631e677960651775c8f6e84735cd5ddc93fea895ef"
        )
    ]
)
