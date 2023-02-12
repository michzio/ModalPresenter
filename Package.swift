// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModalPresenter",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "ModalPresenter", targets: ["ModalPresenter"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.4"),
    ],
    targets: [
        .target(
            name: "ModalPresenter",
            dependencies: [.product(name: "Introspect", package: "SwiftUI-Introspect")],
            path: "Sources"
        ),
        .testTarget(
            name: "ModalPresenterTests",
            dependencies: ["ModalPresenter"]
        ),
    ]
)
