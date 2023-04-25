// swift-tools-version:5.3
import PackageDescription
import Foundation
let package = Package(
    name: "LibMobileCoin",
    platforms: [
        .iOS(.v13),
            .macOS(.v11)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
        .library(
            name: "CoreHTTP",
            targets: ["CoreHTTP"])
    ],
    dependencies: [
        // Here we define our package's external dependencies
        // and from where they can be fetched:
        .package(
            url: "https://github.com/apple/swift-protobuf",
            from: "1.5.0"
        ),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: ["swift-protobuf","grpc-swift","LibMobileCoinFramework"],
            path: "Sources"
        ),
        .target(
            name: "CoreHTTP",
            dependencies: ["swift-protobuf","LibMobileCoinFramework"]),
            path: "Sources",
            exclude: [
                "*grpc.http",
            ]
        ),
        .binaryTarget(
            name: "LibMobileCoinFramework",
            url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "57296f5272a05c82a9a31d1f56f360ba63218a2c2a1bf22778529bf2da09994b"),
    ]
)
