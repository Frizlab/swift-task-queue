import Foundation
import XCTest

import TaskQueueTestHelpers

@testable import TaskQueue



final class TaskQueueTests : XCTestCase {
	
	func testSequence() async throws {
		let slowTasks = DoSlowTasks()
		await withTaskGroup(of: Void.self, body: { tg in
			for i in 0..<9 {
				print("Before adding Task")
				tg.addTask{
					print("Before connect call in Task")
					_ = try? await slowTasks.connect(scope: i, auth: ())
					print("After connect call in Task")
				}
				print("After adding Task")
			}
		})
	}
	
	func testNothing() async {
		await withTaskGroup(of: Void.self, body: { tg in
			tg.addTask{ await Task.sleep(UInt64(1e9)) }
			tg.addTask{ await Task.sleep(UInt64(1e9)) }
			tg.addTask{ await Task.sleep(UInt64(1e9)) }
		})
	}
	
}
