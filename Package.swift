// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "swift-task-queue",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
	products: [.library(name: "TaskQueue", targets: ["TaskQueue"])],
	targets: [
		.target(name: "TaskQueue"),
		.target(name: "TaskQueueTestHelpers"),
		.testTarget(name: "TaskQueueTests", dependencies: ["TaskQueue", "TaskQueueTestHelpers"]),
		.executableTarget(name: "TaskQueueManualTests", dependencies: ["TaskQueue", "TaskQueueTestHelpers"])
	]
)
