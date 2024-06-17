//
//  NSRunningApplication+Browsers.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

#if os(macOS)
import Foundation
import Cocoa

extension NSRunningApplication {
	var isBrowser: Bool {
		browserKind != nil
	}
	
	var browserKind: BrowserKind? {
		BrowserKind.allCases.first { $0.bundleIdentifier == bundleIdentifier }
	}
	
	static func isRunning(browser: BrowserKind) -> Bool {
		NSWorkspace.shared.runningApplications.contains { $0.bundleIdentifier == browser.bundleIdentifier }
	}
}
#endif
