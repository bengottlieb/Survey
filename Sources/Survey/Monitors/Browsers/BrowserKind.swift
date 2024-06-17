//
//  BrowserKind.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

public enum BrowserKind: Int, CaseIterable, Codable, Comparable, Hashable { case safari, chrome, opera
	public var bundleIdentifier: String {
		switch self {
		case .chrome: return "com.google.Chrome"
		case .safari: return "com.apple.Safari"
		case .opera: return "com.operasoftware.Opera"
		}
	}
	
	public static func <(lhs: BrowserKind, rhs: BrowserKind) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
	
	public var imageName: String {
		switch self {
		case .safari: return "safari_icon"
		case .chrome: return "chrome_icon"
		case .opera: return "none"
		}
	}
	
	public var abbreviation: String {
		switch self {
		case .safari: return "S"
		case .chrome: return "G"
		case .opera: return "O"
		}
	}
}
