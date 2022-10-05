import Foundation

import TaskQueue



public actor DoSlowTasks : HasTaskQueue {
	
	public typealias Scope = Int
	public typealias Authentication = Void
	
	var currentScope: Int? = nil
	
	public init() {
	}
	
	public func connect(scope: Int, auth: Void) async throws -> Scope {
		return try await executeOnTaskQueue{ () -> Scope in
			try await self._connect(scope: scope, auth: auth)
		}
	}
	
	public var _taskQueue = TaskQueue()
	
	private func _connect(scope: Int, auth: Void) async throws -> Scope {
		print("*** Start connection \(scope)")
		defer {print("*** End connection \(scope)")}
		
		struct Nope : Error {}
		if (0..<3).randomElement() == 0 {
			throw Nope()
		}
		try await Task.sleep(nanoseconds: UInt64(1e9))
		
		currentScope = scope
		return scope
	}
	
}
