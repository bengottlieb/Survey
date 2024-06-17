//
//  RunningApplicationState.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public struct RunningApplicationState: Codable {
	public let all: RunningApplicationCollection
	public let front: RunningApplication?
	
	#if os(macOS)
	public static var current: RunningApplicationState {
		.init(all: .current, front: .frontmost)
	}
	#endif
	
	func diffs(since origin: RunningApplicationState) -> Diffs {
		.init(all: all.diffs(since: origin.all), front: origin.front == front ? nil : front)
	}
	
	struct Diffs: Codable, CustomStringConvertible {
		var date = Date()
		let all: RunningApplicationCollection.Diffs
		let front: RunningApplication?
		
		var isEmpty: Bool { all.isEmpty && front == nil }
		
		var events: [RecordedEvent] {
			var results: [RecordedEvent] = []

			if let front { results.append(.applicationEvent(.switchedToApp(front), date)) }
			for app in all.opened { results.append(.applicationEvent(.openedApp(app), date)) }
			for app in all.closed { results.append(.applicationEvent(.closedApp(app), date)) }

			return results
		}
		
		var description: String {
			if all.isEmpty, front == nil {
				return ""
			} else if let front {
				if all.isEmpty {
					return "Switched to \(front.name)"
				} else {
					return all.description + ", Switched to \(front.name)"
				}
			} else {
				return all.description
			}
		}
		
	}
}
