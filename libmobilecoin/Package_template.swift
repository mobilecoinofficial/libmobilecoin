// swift-tools-version:5.3
import PackageDescription
import Foundation
let package = Package(
    name: "LibMobileCoin",
    dependencies: [
        // Here we define our package's external dependencies
        // and from where they can be fetched:
        .package(
            url: "https://github.com/apple/swift-protobuf",
            from: "1.5.0"
        ),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0")
    ],
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
            targets: ["CoreHTTP"]),
    ],
    targets: [
        .target(
            name: "Core",
            path: "Sources",
            exclude: [
                "*.http",
            ],
            dependencies: ["SwiftProtobuf","GRPC","LibMobileCoinFramework"]),
        .target(
            name: "CoreHTTP",
            dependencies: ["SwiftProtobuf","LibMobileCoinFramework"]),
        .binaryTarget(
            name: "LibMobileCoinFramework",
            url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "sha256checksum"),
    ]
)
