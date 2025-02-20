//
//  BrowserEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum BrowserEvent: Codable, CustomStringConvertible, Equatable, Hashable, Sendable {
	case initialState(BrowserState)
	case openedTab(BrowserTabInformation)
	case closedTab(BrowserTabInformation, TimeInterval?)
	case switchedToTab(BrowserTabInformation)
	case switchedAwayFromTab(BrowserTabInformation, TimeInterval?)
	
	var id: String { description }
	
	public func matches(filter: String) -> Bool {
		if filter.isEmpty { return true }
		if let url, url.absoluteString.contains(filter) { return true }
		return description.localizedCaseInsensitiveContains(filter)
	}
	
	public var description: String {
		switch self {
		case .initialState(let state): "Starting tabs: \(state.all.count)"
		case .openedTab(let tab): "Opened \(tab.title ?? "--")"
		case .closedTab(let tab, let duration): "Closed \(tab.title ?? "--") \(duration?.durationString(style: .secondsMaybeHours, showLeadingZero: true) ?? "")"
		case .switchedToTab(let tab): "Switched to \(tab.title ?? "--")"
		case .switchedAwayFromTab(let tab, let duration):
			"Switched away from \(tab.title ?? "") \(duration?.durationString(style: .secondsMaybeHours, showLeadingZero: true) ?? "")s"
		}
	}
	
	public var title: String { description }
	
	public var subtitle: String? {
		switch self {
		case .initialState: nil
		case .openedTab(let tab): tab.url.absoluteString
		case .closedTab(let tab, _): tab.url.absoluteString
		case .switchedToTab(let tab): tab.url.absoluteString
		case .switchedAwayFromTab(let tab, _): tab.url.absoluteString
		}
	}
	
	public var url: URL? {
		switch self {
		case .initialState: nil
		case .openedTab(let tab): tab.url
		case .closedTab(let tab, _): tab.url
		case .switchedToTab(let tab): tab.url
		case .switchedAwayFromTab(let tab, _): tab.url
		}
	}
}
