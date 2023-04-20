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
                checksum: "87a1a60112bc3d2dc5b6b3b3ea87b09abd9c4d11dbdceb90e98dc74b672855c3"),
        ]
)
