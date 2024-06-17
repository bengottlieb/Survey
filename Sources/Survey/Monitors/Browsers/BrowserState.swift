//
//  BrowserState.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public struct BrowserState: Codable, Equatable, Hashable {
	public let all: BrowserTabCollection
	public let visible: BrowserTabCollection

	func diffs(since origin: BrowserState) -> Diffs {
		.init(all: all.diffs(since: origin.all), visible: visible.diffs(since: origin.visible))
	}

	struct Diffs: Codable, CustomStringConvertible {
		var date = Date()
		let all: BrowserTabCollection.Diffs
		let visible: BrowserTabCollection.Diffs
		
		var isEmpty: Bool { all.isEmpty && visible.isEmpty }
		
		var description: String {
			if all.isEmpty {
				if visible.opened.isEmpty{
					"Visible: \(visible)"
				} else {
					"Switched to \(visible)"
				}
			} else if visible.isEmpty {
				"All: \(all)"
			} else {
				"All: \(all), Visible: \(visible)"
			}
		}
		
		func events(basedOn history: [RecordedEvent]) -> [RecordedEvent] {
			var results: [RecordedEvent] = []

			for tab in all.opened { results.append(.browserEvent(.openedTab(tab), date)) }
			for tab in all.closed { results.append(.browserEvent(.closedTab(tab, history.mostRecentOpenTabEvent(for: tab)?.age), date)) }

			for tab in visible.opened { results.append(.browserEvent(.switchedToTab(tab), date)) }
			for tab in visible.closed { results.append(.browserEvent(.switchedAwayFromTab(tab, history.mostRecentOpenTabEvent(for: tab)?.age), date))}

			return results
		}

	}
}
