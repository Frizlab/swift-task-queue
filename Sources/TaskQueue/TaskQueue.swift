import Foundation



public typealias TaskQueue = [Task<any Sendable, Error>]


public protocol HasTaskQueue : Actor {
	
	var _taskQueue: TaskQueue {get set}
	
}


public extension HasTaskQueue {
	
	func executeOnTaskQueue<R : Sendable>(_ block: @escaping @Sendable () async throws -> R) async rethrows -> R {
		/* rethrows compiler dance is from <https://oleb.net/blog/2018/02/performandwait/>.
		 * I’m not sure how it works, but it seems to work. */
		return try await _executeOnTaskQueue(execute: block, rescue: { throw $0 })
	}
	
	private func executeOnTaskQueueNoThrow<R : Sendable>(_ block: @escaping @Sendable () async throws -> R) async -> Result<R, any Error> {
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
		return await newTask.result.map{ $0 as! R }
	}
	
	/**
	 Helper function for convincing the type checker that the `rethrows` invariant holds for `executeOnTaskQueue()`.
	 
	 Adapted from:
	  <https://oleb.net/blog/2018/02/performandwait/>, who got is from
	  <https://github.com/apple/swift/blob/bb157a070ec6534e4b534456d208b03adc07704b/stdlib/public/SDK/Dispatch/Queue.swift#L228-L249>. */
	private func _executeOnTaskQueue<R : Sendable>(
		execute work: @escaping @Sendable () async throws -> R,
		rescue: (Error) throws -> R
	) async rethrows -> R {
		let r = await executeOnTaskQueueNoThrow(work)
		switch r {
			case let .failure(e): return try rescue(e)
			case let .success(r): return r
		}
	}
	
}
