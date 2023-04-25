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
            targets: ["Common", "HTTPInterface", "CoreHTTP", "Core"]),
        .library(
            name: "CoreHTTP",
            targets: ["Common", "HTTPInterface", "CoreHTTP"])
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
            name: "TestVectorUtils",
            dependencies: [],
            path: "Sources/TestVector/Util"
         ),
        .target(
            name: "Common",
            dependencies: [.product(name: "SwiftProtobuf", package: "swift-protobuf")],
            path: "Sources/Generated/Proto/PB"
         ),
        .target(
            name: "HTTPInterface",
            dependencies: [],
            path: "Sources/Interface"
        ),
        .target(
            name: "CoreHTTP",
            dependencies: ["Common", "HTTPInterface", "TestVectorUtils", "LibMobileCoin"],
            path: "Sources/Generated/Proto/HTTP"
        ),
        .target(
            name: "Core",
            dependencies: ["CoreHTTP", .product(name: "GRPC", package: "grpc-swift")],
            path: "Sources/Generated/Proto/GRPC"
        ),
        .binaryTarget(
            name: "LibMobileCoin",
            url: "https://yus.s3.us-east-1.amazonaws.com/bundle.zip",
            // url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/adam/%23184377543-3/Artifacts/bundle.zip",
            checksum: "sha256checksum")
    ]
)

