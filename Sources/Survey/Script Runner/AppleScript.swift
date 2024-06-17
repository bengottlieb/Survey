//
//  AppleScript.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

// osascript -e 'tell application "Safari" to get URL of current tab of front window'

public protocol RunnableScript {
	var script: String { get }
}

public struct AppleScript {
	
}

