import Foundation

import TaskQueueTestHelpers



/* This exists because the ThreadSanitizer throws a lot of runtime issues when running in test case, but not here… */
@main
struct ManualTests {
	
	static func main() async throws {
		await withTaskGroup(of: Void.self, body: { tg in
			tg.addTask{ await Task.sleep(UInt64(1e9)) }
			tg.addTask{ await Task.sleep(UInt64(1e9)) }
			tg.addTask{ await Task.sleep(UInt64(1e9)) }
		})
		
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
		print("all done")
	}
	
}
