// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "sweet",

  products: [
    .executable(
      name: "sweet",
      targets: ["sweet"])
  ],

  dependencies: [
  ],
  
  targets: [
    .executableTarget(
      name: "sweet",
      dependencies: []),
  ]
)
