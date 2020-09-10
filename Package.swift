// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "MustacheUIKit",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(name: "MustacheUIKit", targets: ["MustacheUIKit"]),
  ],
  dependencies: [
   .package(url: "https://github.com/mustachedk/MustacheFoundation", .upToNextMajor(from: "2.0.0")),
   .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "5.0.0")),
 ],
  targets: [
    .target(name: "MustacheUIKit", dependencies: ["MustacheFoundation", "Kingfisher"])
  ]
)
