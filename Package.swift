// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GitlabAPI",
	platforms: [.macOS(.v15)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "GitlabAPI",
			targets: ["GitlabAPI"])
	],
	dependencies: [
		.package(url: "https://github.com/NinjaLikesCheez/swift-api-client", branch: "main")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "GitlabAPI",
			dependencies: [.product(name: "APIClient", package: "swift-api-client")]
		),
		.testTarget(
			name: "GitlabAPITests",
			dependencies: ["GitlabAPI"]
		),
	]
)
