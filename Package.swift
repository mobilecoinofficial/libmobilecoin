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
            name: "LibMobileCoinCoreProduct",
            targets: ["LibMobileCoinCore", "LibMobileCoin"]),
        .library(
            name: "LibMobileCoinCoreHTTPProduct",
            targets: ["LibMobileCoinCoreHTTP", "LibMobileCoin"])
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
            name: "Common",
            dependencies: [.product(name: "SwiftProtobuf", package: "swift-protobuf")],
            path: "Sources/Common"
         ),
        .target(
            name: "LibMobileCoinCoreHTTP",
            dependencies: [.target(name: "Common")],
            path: "Sources/HTTP"
        ),
        .target(
            name: "LibMobileCoinCore",
            dependencies: [.target(name: "Common"), .product(name: "GRPC", package: "grpc-swift")],
            path: "Sources/GRPC"
        ),
        .binaryTarget(
            name: "LibMobileCoin",
            url: "https://yus.s3.us-east-1.amazonaws.com/bundle.zip",
            // url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "33d4a839ab2c3ca87754ac4c5a6a658a77429b58202254152c5923629718fc36")
    ]
)

