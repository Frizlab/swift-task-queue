import Foundation

import TaskQueue



public actor DoSlowTasks : HasTaskQueue {
	
	typealias Scope = Int
	typealias Authentication = Void
	
	var currentScope: Int? = nil
	
	public init() {
	}
	
	public func connect(scope: Int, auth: Void) async throws -> Int {
		return try await executeOnTaskQueue{ () -> Scope in
			print("*** Start connection \(scope)")
			defer {print("*** End connection \(scope)")}
			
			struct Nope : Error {}
			if (0..<3).randomElement() == 0 {
				throw Nope()
			}
			await Task.sleep(UInt64(1e9))
			
			self.currentScope = scope
			return scope
		}
	}
	
	public var _taskQueue = [Task<Any, Error>]()
	
}
