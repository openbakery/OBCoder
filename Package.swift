// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "OBCoder",
	platforms: [
		.iOS(.v14)
	],
	products: [
		.library(name: "OBCoder", targets: ["OBCoder"])
	],
	dependencies: [
		.package(
			url: "https://github.com/nschum/SwiftHamcrest/",
			.exact(from: "2.2.4")
		)
	],
	targets: [
		.target(
			name: "OBCoder",
			dependencies: [],
			path: "Main",
			sources: [
				"Source"
			]
		),
		.testTarget(
			name: "OBCoderTests",
			dependencies: ["OBCoder", "SwiftHamcrest"],
			path: "Test",
			sources: [
				"Source"
			]
		)
	]
)
