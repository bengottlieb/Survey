//
//  RunningApplication.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public struct RunningApplication: Codable, Hashable, Identifiable, Sendable {
	public var id: String { identifier }
	public let identifier: String
	public let name: String
}

#if os(macOS)
import Cocoa

extension RunningApplication {
	init?(_ app: NSRunningApplication?) {
		guard let ident = app?.bundleIdentifier, let name = app?.localizedName else { return nil }
		identifier = ident
		self.name = name
	}
	
	static var frontmost: RunningApplication? {
		RunningApplication(NSWorkspace.shared.frontmostApplication)
	}
}
#endif
