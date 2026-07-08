// swift-tools-version: 6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftBooster",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "SwiftBooster",
            targets: ["SwiftBooster"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            exact: "602.0.0"
        ),
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            from: "2.10.0"
        )
    ],
    targets: [

        .macro(
            name: "SwiftBoosterMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .target(
            name: "SwiftBooster",
            dependencies: [
                "SwiftBoosterMacros",
                .product(name: "Swinject", package: "Swinject")
            ]
        ),

        // Optional. Keep only for local development.
        .executableTarget(
            name: "SwiftBoosterClient",
            dependencies: ["SwiftBooster"]
        )
    ]
)
