// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaporWave",
    platforms: [
       .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
      .library(name: "VaporWaveService", targets: ["VaporWaveService"]),
      .library(name: "VaporWaveModels", targets: ["VaporWaveModels"]),
      .library(
          name: "VaporWaveServer",
          targets: ["VaporWaveServer"]
      ),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),        
          .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-vapor", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
      .target(name: "VaporWaveModels"),
      .target(name: "VaporWaveService", dependencies: [ "VaporWaveModels", "VaporWaveServer"]),
      .target(
          name: "VaporWaveServer",
          dependencies: [
            "VaporWaveModels",
              .product(name: "Vapor", package: "vapor"),                
              .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            .product(name: "OpenAPIVapor", package: "swift-openapi-vapor")
          ],
      plugins: [
            .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
        ])
    ]
)
