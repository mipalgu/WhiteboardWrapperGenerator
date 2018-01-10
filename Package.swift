// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhiteboardWrapperGenerator",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WhiteboardWrapperGenerator",
            dependencies: ["Config", "DataStructures", "FileGenerators", "Parsers"]),
        .target(
            name: "NamingFuncs",
            dependencies: []),
        .target(
            name: "Config",
            dependencies: []),
        .target(
            name: "DataStructures",
            dependencies: ["Protocols"]),
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
