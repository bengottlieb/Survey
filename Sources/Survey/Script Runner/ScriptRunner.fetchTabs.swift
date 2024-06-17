//
//  ScriptRunner.fetchTabs.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

#if os(macOS)
import Foundation
import Cocoa

extension ScriptRunner {
	
	func fetchTabs(for script: AppleScript.TabFetcher) async -> BrowserTabCollection {
		guard NSRunningApplication.isRunning(browser: script.browser) else { return .empty }

		do {
			let raw = try await run(command: script)
			return try script.tabs(from: raw)
		} catch {
			print("Failed to run \(script.title): \(error)")
			return .empty
		}
	}
}
#endif
