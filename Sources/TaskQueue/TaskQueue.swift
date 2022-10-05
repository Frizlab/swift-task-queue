import Foundation



public typealias TaskQueue = [Task<any Sendable, Error>]


public protocol HasTaskQueue : Actor {
	
	var _taskQueue: TaskQueue {get set}
	
}


public extension HasTaskQueue {
	
	func executeOnTaskQueue<Result : Sendable>(_ block: @escaping @Sendable () async throws -> Result) async throws -> Result {
		let latestTask = _taskQueue.last
		let newTask = Task{ () async throws -> any Sendable in
			/* We wait for previous task to finish */
			_ = await latestTask?.result
			return try await block()
		}
		_taskQueue.append(newTask)
		/* Note: We might not remove our own task from the _taskQueue array because of races.
		 * It should not a big deal because the other execution that has raced us will have removed our task.
		 * In the end all of the tasks should be removed. */
		defer {_taskQueue.removeFirst()}
		let ret = try await newTask.value as! Result
		return ret
	}
	
}
