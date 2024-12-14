//
//  AppleScript.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/11/21.
//

import Foundation

extension AppleScript {
	public enum TabFetcher: String, CaseIterable, Identifiable, Hashable, RunnableScript {
		case safariFrontmostTab = "Frontmost Tab for Safari", safariFrontmostTabText = "Frontmost tab text for Safari", safariFrontmostTabSource = "Frontmost tab source for Safari", safariAllFrontWindowTabs = "All Front Window Tabs for Safari", safariAllVisibleTabs = "All Visible Tabs for Safari", safariAllTabs = "All Tabs for Safari"
		
		case chromeFrontmostTab = "Frontmost Tab for Chrome", chromeFrontmostTabSource = "Frontmost tab source for Chrome", chromeFrontmostTabText = "Frontmost tab text for Chrome", chromeAllFrontWindowTabs = "All Front Window Tabs for Chrome", chromeAllVisibleTabs = "All Visible Tabs for Chrome", chromeAllTabs = "All Tabs for Chrome"

		case operaFrontmostTab = "Frontmost Tab for Opera", operaAllFrontWindowTabs = "All Front Window Tabs for Opera", operaAllVisibleTabs = "All Visible Tabs for Opera", operaAllTabs = "All Tabs for Opera"
		
		public var script: String {
			switch self {
			case .safariFrontmostTab: return "tell application \"Safari\" to get {name, URL} of current tab of front window"
			case .safariFrontmostTabText: return "tell application \"Safari\" to get {text} of current tab of front window"
			case .safariFrontmostTabSource: return "tell application \"Safari\" to get {source} of current tab of front window"
			case .safariAllFrontWindowTabs: return "tell application \"Safari\" to get {name, URL} of every tab of front window"
			case .safariAllVisibleTabs: return "tell application \"Safari\" to get {name, URL} of current tab of every window"
			case .safariAllTabs: return "tell application \"Safari\" to get {name, URL} of every tab of every window"

			case .chromeFrontmostTab: return "tell application \"Google Chrome\" to get (title, URL) of active tab of front window"
			case .chromeAllFrontWindowTabs: return "tell application \"Google Chrome\" to get (title, URL) of every tab of front window"
			case .chromeAllVisibleTabs: return "tell application \"Google Chrome\" to get (title, URL) of active tab of every window"
			case .chromeFrontmostTabSource: return "tell application \"Google Chrome\" to execute front window's active tab javascript \"document.body.innerHTML\""
			case .chromeFrontmostTabText: return "tell application \"Google Chrome\" to execute front window's active tab javascript \"document.body.innerText\""
			case .chromeAllTabs: return "tell application \"Google Chrome\" to get (title, URL) of every tab of every window"

			case .operaFrontmostTab: return "tell application \"Opera\" to get (title, URL) of active tab of front window"
			case .operaAllFrontWindowTabs: return "tell application \"Opera\" to get (title, URL) of every tab of front window"
			case .operaAllVisibleTabs: return "tell application \"Opera\" to get (title, URL) of active tab of every window"
			case .operaAllTabs: return "tell application \"Opera\" to get (title, URL) of every tab of every window"
			}
		}
		
		public var title: String { rawValue }
		public var id: String { rawValue }
		public func hash(into hasher: inout Hasher) {
			rawValue.hash(into: &hasher)
		}
		
		public var browser: BrowserKind {
			switch self {
			case .safariAllTabs, .safariFrontmostTab, .safariFrontmostTabText, .safariFrontmostTabSource, .safariAllVisibleTabs, .safariAllFrontWindowTabs: .safari
			case .chromeAllTabs, .chromeFrontmostTab, .chromeFrontmostTabSource, .chromeFrontmostTabText, .chromeAllVisibleTabs, .chromeAllFrontWindowTabs: .chrome
			case .operaFrontmostTab, .operaAllVisibleTabs, .operaAllFrontWindowTabs, .operaAllTabs: .opera
			}
		}
		
		public func tabs(from string: String) throws -> BrowserTabCollection {
			let raw: [BrowserTabInformation] = switch self {
			case .safariAllTabs: try [BrowserTabInformation](namesAndURLsByWindow: string, browser: .safari)
			case .safariFrontmostTab: try [BrowserTabInformation](tabNameAndURL: string, browser: .safari)
			case .safariFrontmostTabText: fatalError("Not implemented")
			case .safariFrontmostTabSource: fatalError("Not implemented")
			case .safariAllVisibleTabs: try [BrowserTabInformation](namesAndURLs: string, browser: .safari)
			case .safariAllFrontWindowTabs: try [BrowserTabInformation](namesAndURLs: string, browser: .safari)

			case .chromeAllTabs: try [BrowserTabInformation](namesAndURLsByWindow: string, browser: .chrome)
			case .chromeFrontmostTab: try [BrowserTabInformation](tabNameAndURL: string, browser: .chrome)
			case .chromeFrontmostTabText: fatalError()
			case .chromeFrontmostTabSource: fatalError()
			case .chromeAllVisibleTabs: try [BrowserTabInformation](namesAndURLs: string, browser: .chrome)
			case .chromeAllFrontWindowTabs: try [BrowserTabInformation](namesAndURLs: string, browser: .chrome)

			case .operaAllTabs: try [BrowserTabInformation](namesAndURLsByWindow: string, browser: .opera)
			case .operaFrontmostTab: try [BrowserTabInformation](tabNameAndURL: string, browser: .opera)
			case .operaAllVisibleTabs: try [BrowserTabInformation](namesAndURLs: string, browser: .opera)
			case .operaAllFrontWindowTabs: try [BrowserTabInformation](namesAndURLs: string, browser: .opera)
			}
			
			return BrowserTabCollection(tabs: .init(raw))
		}
	}
}

extension [AppleScript.TabFetcher] {
	public static var allSafariScripts: [AppleScript.TabFetcher] { [ .safariFrontmostTab, .safariAllFrontWindowTabs, .safariAllVisibleTabs, .safariAllTabs ] }
	public static var allChromeScripts: [AppleScript.TabFetcher] { [ .chromeFrontmostTab, .chromeAllFrontWindowTabs, .chromeAllVisibleTabs, .chromeAllTabs ] }
	public static var allOperaScripts: [AppleScript.TabFetcher] { [ .operaFrontmostTab, .operaAllFrontWindowTabs, .operaAllVisibleTabs, .operaAllTabs ] }
}
