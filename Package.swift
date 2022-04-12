// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sodi",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Sodi",
            targets: ["Sodi"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Sodi",
            dependencies: []),
//        .binaryTarget(
//                    name: "SodiRemoteBinaryPackage",
//                    url: "https://github.com/Rasalexman/Sodi/archive/refs/tags/1.0.0.zip",
//                    checksum: "The checksum of the ZIP archive that contains the XCFramework."
//                ),
//                .binaryTarget(
//                    name: "SomeLocalBinaryPackage",
//                    path: "path/to/some.xcframework"
//                )
        .testTarget(
            name: "SodiTests",
            dependencies: ["Sodi"]),
    ]
)
