//
//  ScriptRunner.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

#if os(macOS)

import Foundation
import Combine
import Suite

public actor ScriptRunner {
	public static let instance = ScriptRunner()
	enum ScriptError: Error { case noOSAScriptFound, unableToDecodeString }
	
	var cancellables = Set<AnyCancellable>()
	init() {
	}
	
	public func loadOSAScript() async throws -> String {
		if let osascriptPath { return osascriptPath }
		do {
			let path = try await Process.which("osascript")

			self.osascriptPath = path
			return path
		} catch {
			throw ScriptError.noOSAScriptFound
		}
	}
	
	public func setup() {
		
	}
	public var osascriptPath: String?
	
	public func runForData(script: String) async throws -> Data {
		try await Process(path: loadOSAScript(), arguments: ["-e", "\(script)", "-ss"]).run()
	}
	
	public func run(script: String) async throws -> String {
		let data = try await runForData(script: script)
		if let string = String(data: data, encoding: .utf8) { 
			return string
		}
		throw ScriptError.unableToDecodeString
	}
	
	func run(command: RunnableScript) async throws -> String { try await run(script: command.script) }
}
#endif
