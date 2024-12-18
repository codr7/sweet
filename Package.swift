// swift-tools-version:6.0.2

import PackageDescription

let package = Package(
  name: "sweet",

  platforms: [
    .macOS(.v15)
  ],
    
  products: [
    .executable(
      name: "sweet",
      targets: ["sweet"])
  ],

  dependencies: [
    .package(url: "https://github.com/apple/swift-system", from: "1.4.0"),
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
  ],
  
  targets: [
    .executableTarget(
      name: "sweet",
      dependencies: [
        .product(name: "SystemPackage", package: "swift-system"),
        .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "NIOEmbedded", package: "swift-nio"),
        .product(name: "NIOPosix", package: "swift-nio"),
      ],
      swiftSettings: [
        .swiftLanguageMode(.v6),
      ]),
  ]
)
