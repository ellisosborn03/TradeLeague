// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TradeLeague",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TradeLeague",
            targets: ["TradeLeague"])
    ],
    dependencies: [
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "TradeLeague",
            dependencies: [
                .product(name: "Pow", package: "Pow")
            ]),
        .testTarget(
            name: "TradeLeagueTests",
            dependencies: ["TradeLeague"])
    ]
)