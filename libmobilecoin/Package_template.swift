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
                name: "LibMobileCoin",
                targets: ["LibMobileCoin"]),
        ],
        targets: [
            .target(
                name: "LibMobileCoin",
                dependencies: ["LibMobileCoinFramework"]),
            .binaryTarget(
                name: "LibMobileCoinFramework",
                url: "https://github.com/mobilecoinofficial/libmobilecoin/blob/master/Artifacts/bundle.zip",
                checksum: "sha256checksum"),
        ]
)
