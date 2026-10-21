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
            url: "https://github.com/unionst/swift-chat/releases/download/1.0.10/UnionChat.xcframework.zip",
            checksum: "cd240ef27ce19583c6775fa69c968505e3526ac2b6a94c0eeff6dabd6ee399c1"
        )
    ]
)
