//
//  ApplicationEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum ApplicationEvent: Codable, Equatable, Hashable, Sendable {
	case initialState(RunningApplicationCollection)
	case openedApp(RunningApplication)
	case closedApp(RunningApplication)
	case switchedToApp(RunningApplication)
	
	var id: String { description }
	
	public func matches(filter: String) -> Bool {
		filter.isEmpty || description.localizedCaseInsensitiveContains(filter)
	}

	public var description: String {
		switch self {
		case .initialState(let state): "Starting apps: \(state.apps.count)"
		case .openedApp(let app): "Opened \(app.name)"
		case .closedApp(let app): "Closed \(app.name)"
		case .switchedToApp(let app): "Switched to \(app.name)"
		}
	}
}
