// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhiteboardWrapperGenerator",
    dependencies: [
        .package(url: "ssh://git.mipal.net/git/whiteboard_helpers.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "WhiteboardWrapperGenerator",
            dependencies: ["DataStructures", "FileGenerators", "Parsers"]),
        .target(
            name: "NamingFuncs",
            dependencies: ["DataStructures", "whiteboard_helpers"]),
        .target(
            name: "DataStructures",
            dependencies: ["Protocols", "whiteboard_helpers"]),
        .target(
            name: "FileGenerators",
            dependencies: ["DataStructures", "NamingFuncs"]),
        .target(
            name: "Parsers",
            dependencies: ["DataStructures", "ParserFuncs"]),
        .target(
            name: "ParserFuncs",
            dependencies: ["Protocols"]),
        .target(
            name: "Protocols",
            dependencies: []),
    ]
)
