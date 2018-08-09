// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "kAPNS",
    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.4.0")),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMinor(from: "1.7.1")),
      .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.4.0"),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "8.0.0"),
      .package(url: "https://github.com/IBM-Swift/Kitura-net.git", from: "2.1.0"),
      .package(url: "https://github.com/vapor/sqlite.git", from: "3.0.0-rc.4.1"),
      .package(url: "https://github.com/ainame/Swift-Daemon.git", from: "0.0.3"),
    ],
    targets: [
      .target(name: "kAPNS", dependencies: [ .target(name: "Application"), "Kitura", "HeliumLogger"]),
      .target(name: "Application", dependencies: [ "Kitura", "SQLite", "SwiftMetrics", "KituraNet", "CloudEnvironment", "Daemon" ]),
      .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura","HeliumLogger" ])
    ]
)
