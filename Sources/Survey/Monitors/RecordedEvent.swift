//
//  RecordedEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum RecordedEvent: Codable, CustomStringConvertible, Equatable, Hashable, Identifiable, Sendable {
	case browserEvent(BrowserEvent, Date)
	case applicationEvent(ApplicationEvent, Date)
	
	public var id: String {
		switch self {
		case .browserEvent(let event, let date): event.id + "\(date.timeIntervalSinceReferenceDate)"
		case .applicationEvent(let event, let date): event.id + "\(date.timeIntervalSinceReferenceDate)"
		}
	}
	
	public var url: URL? {
		switch self {
		case .browserEvent(let event, _): event.url
		default: nil
		}
	}
	
	public func matches(filter: String) -> Bool {
		switch self {
		case .browserEvent(let event, _): event.matches(filter: filter)
		case .applicationEvent(let event, _): event.matches(filter: filter)
		}
	}

	public var title: String {
		switch self {
		case .browserEvent(let event, _): event.title
		case .applicationEvent: description
		}
	}

	public var subtitle: String? {
		switch self {
		case .browserEvent(let event, _): event.subtitle
		case .applicationEvent: nil
		}
	}

	public var description: String {
		switch self {
		case .browserEvent(let event, _): event.description
		case .applicationEvent(let event, _): event.description
		}
	}
	
	var age: TimeInterval {
		switch self {
		case .browserEvent(_, let date): abs(date.timeIntervalSinceNow)
		case .applicationEvent(_, let date): abs(date.timeIntervalSinceNow)
		}
	}
}

extension [RecordedEvent] {
	func mostRecentOpenTabEvent(for tab: BrowserTabInformation) -> RecordedEvent? {
		for event in reversed() {
			if case let .browserEvent(browserEvent, _) = event {
				if case let .openedTab(opened) = browserEvent, opened.url == tab.url { return event }
				if case let .initialState(state) = browserEvent, state.all.contains(tab.url) { return event }
			}
			
			
		}
		return nil
	}
	
	func mostRecentSwitchToTabEvent(for tab: BrowserTabInformation) -> RecordedEvent? {
		for event in reversed() {
			if case let .browserEvent(browserEvent, _) = event {
				if case let .switchedToTab(opened) = browserEvent, opened.url == tab.url { return event }
				if case let .initialState(state) = browserEvent, state.all.contains(tab.url) { return event }
			}
		}
		return nil
	}
}
