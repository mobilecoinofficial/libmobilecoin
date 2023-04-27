// swift-tools-version:5.7
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
            name: "LibMobileCoinCore",
            targets: ["LibMobileCoinTestVector", "LibMobileCoinHTTP", "LibMobileCoinGRPC", "LibMobileCoinCommon", "LibMobileCoin"]),
        .library(
            name: "LibMobileCoinCoreGRPC",
            targets: ["LibMobileCoinTestVector", "LibMobileCoinGRPC", "LibMobileCoinCommon", "LibMobileCoin"]),
        .library(
            name: "LibMobileCoinCoreHTTP",
            targets: ["LibMobileCoinTestVector", "LibMobileCoinHTTP", "LibMobileCoinCommon", "LibMobileCoin"])
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
            name: "LibMobileCoinTestVector",
            dependencies: [],
            path: "Sources/TestVector",
            resources: [
                .copy("vectors")
            ]
         ),
        .target(
            name: "LibMobileCoinCommon",
            dependencies: [.product(name: "SwiftProtobuf", package: "swift-protobuf")],
            path: "Sources/Common"
         ),
        .target(
            name: "LibMobileCoinHTTP",
            dependencies: [.target(name: "LibMobileCoinCommon")],
            path: "Sources/HTTP"
        ),
        .target(
            name: "LibMobileCoinGRPC",
            dependencies: [.target(name: "LibMobileCoinCommon"), .product(name: "GRPC", package: "grpc-swift")],
            path: "Sources/GRPC"
        ),
        .binaryTarget(
            name: "LibMobileCoin",
            url: "https://yus.s3.us-east-1.amazonaws.com/bundle.zip",
            // url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "016385d0c76c857fc5806d9c9e2f985d8bc76b7fffbab4d34814b84b7c9c2a41")
    ]
)

