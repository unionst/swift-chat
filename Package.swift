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
            url: "https://github.com/unionst/swift-chat/releases/download/1.2.2/UnionChat.xcframework.zip",
            checksum: "e0c8aa6747b5742e70226fd0d9a2712ad205541db802aebbb9f3081fc6169de6"
        )
    ]
)
