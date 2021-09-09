// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhiteboardWrapperGenerator",
    products: [
        .executable(name: "WhiteboardWrapperGenerator", targets: ["WhiteboardWrapperGenerator"]),
        .library(name: "WhiteboardWrapperGeneratorLib", targets: ["WhiteboardWrapperGeneratorLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/mipalgu/whiteboard_helpers.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "WhiteboardWrapperGenerator",
            dependencies: ["WhiteboardWrapperGeneratorLib"]),
        .target(
            name: "WhiteboardWrapperGeneratorLib",
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
        .testTarget(
            name: "WhiteboardWrapperGeneratorTests",
            dependencies: ["WhiteboardWrapperGeneratorLib"])
    ]
)
