//
//  RunningApplicationCollection.swift
//  
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

extension Set where Element == RunningApplication {
	var description: String {
		Array(self).map { $0.name }.joined(separator: ", a")
	}
}

public struct RunningApplicationCollection: Codable, Equatable, Hashable, CustomStringConvertible {
	let apps: Set<RunningApplication>
	public var description: String {
		apps.map { $0.name }.joined(separator: ", ")
	}
	
	public struct Diffs: Codable, CustomStringConvertible {
		public let opened: Set<RunningApplication>
		public let closed: Set<RunningApplication>
		
		public var isEmpty: Bool { opened.isEmpty && closed.isEmpty }
		
		public var description: String {
			if opened.isEmpty, closed.isEmpty { return "" }
			if opened.isEmpty { return "Quit \(closed.description)" }
			return "Launched \(opened.description)"
		}
	}
	
	func diffs(since origin: RunningApplicationCollection) -> Diffs {
		let opened = self.apps.subtracting(origin.apps)
		let closed = origin.apps.subtracting(self.apps)
		
		return .init(opened: opened, closed: closed)
	}
	
}

#if os(macOS)
import Cocoa

extension RunningApplicationCollection {
	static var current: RunningApplicationCollection {
		.init(apps: .init(NSWorkspace.shared.runningApplications.compactMap { RunningApplication($0) }))
	}
}

#endif
