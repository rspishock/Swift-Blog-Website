// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftBlogWebsite",
    products: [
        .executable(
            name: "SwiftBlogWebsite",
            targets: ["SwiftBlogWebsite"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "SwiftBlogWebsite",
            dependencies: ["Publish"]
        )
    ]
)