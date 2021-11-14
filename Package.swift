// swift-tools-version:5.5
import PackageDescription


let package = Package(
	name: "swift-task-queue",
	platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)],
	products: [.library(name: "TaskQueue", targets: ["TaskQueue"])],
	targets: [
		.target(name: "TaskQueue"),
		.target(name: "TaskQueueTestHelpers"),
		.testTarget(name: "TaskQueueTests", dependencies: ["TaskQueue", "TaskQueueTestHelpers"]),
		.executableTarget(name: "TaskQueueManualTests", dependencies: ["TaskQueue", "TaskQueueTestHelpers"])
	]
)
