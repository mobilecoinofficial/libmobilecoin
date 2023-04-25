// swift-tools-version:5.3
import PackageDescription
import Foundation
let package = Package(
    name: "libmobilecoin",
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
            dependencies: ["swift-protobuf", "grpc-swift", "LibMobileCoin"],
            path: "Sources",
            exclude: [ ]),
        .target(
            name: "CoreHTTP",
            dependencies: ["swift-protobuf", "LibMobileCoin"],
            path: "Sources",
            exclude: [
                "Generated/Proto/GRPC"
            ]),
        .binaryTarget(
            name: "LibMobileCoin",
            url: "https://yus.s3.us-east-1.amazonaws.com/bundle.zip",
            // url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "8228b2ae1c07d092e8714ebf5d064ca61303726a79c971cff5980c84f27bc344")
    ]
)
