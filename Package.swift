// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWBankBalanceAnimationLabel",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WWBankBalanceAnimationLabel", targets: ["WWBankBalanceAnimationLabel"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWBankBalanceAnimationLabel", dependencies: []),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
