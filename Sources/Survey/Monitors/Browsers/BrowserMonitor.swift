//
//  BrowserMonitor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

#if os(macOS)
import Foundation
import Cocoa
import Combine

class BrowserMonitor: NSObject {
	static let instance = BrowserMonitor()
	var initialState: BrowserState?
	var lastState: BrowserState?
	var history: [RecordedEvent] = []
	
	@MainActor var checkInterval: TimeInterval = 1 { didSet { Task { setupTimer() }}}
	private weak var checkTimer: Timer?
	private var cancellables = Set<AnyCancellable>()
	weak var delegate: RecordedEventDelegate!
	
	@MainActor func setup(delegate: RecordedEventDelegate) async {
		setupTimer()
		await update()
		self.delegate = delegate

		if let initialState {
			let initialEvent = RecordedEvent.browserEvent(.initialState(initialState), Date())
			history = [initialEvent]
			delegate.receivedEvents([initialEvent])
		}
	}
	
	@MainActor func setupTimer() {
		checkTimer?.invalidate()
		checkTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true, block: { [weak self] _ in
			guard let self else { return }
			Task { await self.update() }
		})
	}
	
	var currentState: BrowserState {
		get async throws {
			async let safariAll = ScriptRunner.instance.fetchTabs(for: .safariAllTabs)
			async let chromeAll = ScriptRunner.instance.fetchTabs(for: .chromeAllTabs)
			async let operaAll = ScriptRunner.instance.fetchTabs(for: .operaAllTabs)

			async let safariVisible = ScriptRunner.instance.fetchTabs(for: .safariAllVisibleTabs)
			async let chromeVisible = ScriptRunner.instance.fetchTabs(for: .chromeAllVisibleTabs)
			async let operaVisible = ScriptRunner.instance.fetchTabs(for: .operaAllVisibleTabs)

			let (all, visible) = (await (safariAll + chromeAll + operaAll), await safariVisible + chromeVisible + operaVisible)
			return BrowserState(all: all, visible: visible)
		}
	}
	
	@objc func update() async {
		do {
			let newState = try await currentState
			guard let lastState else {
				initialState = newState
				lastState = newState
				return
			}
			
			let diff = newState.diffs(since: lastState)
			if !diff.isEmpty {
				self.lastState = newState
				let events = diff.events(basedOn: history)
				history += events
				delegate.receivedEvents(events)
			}
		} catch {
			print("Tab fetching failed: \(error)")
		}
	}
	
//	var safariFrontTabs: [BrowserTabInformation] {
//		get async {
//			guard NSRunningApplication.isRunning(browser: .safari) else { return [] }
//			do {
//				let string = try await ScriptRunner.instance.fetchTabs(for: .safariAllVisibleTabs)
//				return try [BrowserTabInformation](currentSafariTabs: string)
//			} catch {
//				print("Failed to fetch Safari Tabs: \(error)")
//				return []
//			}
//		}
//	}
//
//	var chromeFrontTabs: [BrowserURL] {
//		get async {
//			guard NSRunningApplication.isRunning(browser: .chrome) else { return [] }
//			do {
//				let string = try await ScriptRunner.instance.fetchTabs(for: .chromeAllVisibleTabs)
//				return string.components(separatedBy: ",").compactMap { BrowserURL($0, .chrome) }
//			} catch {
//				return []
//			}
//		}
//	}
//
//	var operaFrontTabs: [BrowserURL] {
//		get async {
//			guard NSRunningApplication.isRunning(browser: .opera) else { return [] }
//			do {
//				let string = try await ScriptRunner.instance.fetchTabs(for: .operaAllVisibleTabs)
//				return string.components(separatedBy: ",").compactMap { BrowserURL($0, .safari) }
//			} catch {
//				return []
//			}
//		}
//	}
}

extension BrowserMonitor {
	func logScriptResults(_ scripts: [AppleScript.TabFetcher]) async {
//		let scripts: [AppleScript.TabFetcher] = [.chromeAllTabs, .chromeFrontmostTab, .chromeAllVisibleTabs, .chromeAllFrontWindowTabs]
		for script in scripts {
			print("SCRIPT: \(script.rawValue) \(script.script)")
			print(await ScriptRunner.instance.fetchTabs(for: script))
			print("SCRIPT END -----------------------------")
		}
	}
}
#endif
