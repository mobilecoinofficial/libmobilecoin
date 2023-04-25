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
            dependencies: ["swift-protobuf", "grpc-swift", "LibMobileCoinFramework"],
            path: "Sources",
            exclude: [
                "*.http"
            ]),
        .target(
            name: "CoreHTTP",
            dependencies: ["swift-protobuf", "LibMobileCoinFramework"]),
        .binaryTarget(
            name: "LibMobileCoinFramework",
            url: "https://yus.s3.us-east-1.amazonaws.com/bundle.zip",
            // url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "517b452481d4aaa8578025bee4ed8b89a6848f0ba7c0ceb6a5553e6dba46931d")
    ]
)
