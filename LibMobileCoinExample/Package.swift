// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LibMobileCoinExample",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "LibMobileCoinExample",
            targets: ["LibMobileCoinExample"]),
    ],
    dependencies: [
        .package(path: "../"),
    ],
    targets: [
        .target(
            name: "LibMobileCoinExample",
            dependencies: [
                .product(name: "LibMobileCoinCoreHTTP", package: "libmobilecoin"),
            ]),
        // TestVectorImports.swift imports LibMobileCoinTestVector, which is its
        // own product, so the test target asks for it explicitly.
        .testTarget(
            name: "LibMobileCoinExampleTests",
            dependencies: [
                "LibMobileCoinExample",
                .product(name: "LibMobileCoinTestVectors", package: "libmobilecoin"),
            ]),
    ]
)
