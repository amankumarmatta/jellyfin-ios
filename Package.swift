// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Jellyfin",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Jellyfin",
            targets: ["Jellyfin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.1"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.15.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "Jellyfin",
            dependencies: [
                "Alamofire",
                "SDWebImage",
                "SwiftyJSON"
            ]),
        .testTarget(
            name: "JellyfinTests",
            dependencies: ["Jellyfin"]),
    ]
) 