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
            url: "https://github.com/unionst/swift-chat/releases/download/1.0.8/UnionChat.xcframework.zip",
            checksum: "06aed89735cb19281afb3f5870df0f7a5f2c9fae0397fef2cbfd98857f19de80"
        )
    ]
)
