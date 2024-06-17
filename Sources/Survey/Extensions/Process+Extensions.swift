//
//  Process+Extensions.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

#if os(macOS)

import Foundation
import Combine
import Suite

extension Process {
	enum ProcessError: Error, LocalizedError { case systemResult(String)
		var errorDescription: String? {
			switch self {
			case .systemResult(let err): return err
			}
		}
	}
	class func which(_ name: String) async throws -> String {
		let data = try await Process(path: "/usr/bin/which", arguments: [name]).run()
		return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
	}
	
	convenience init(path: String, arguments args: [String]) {
		self.init()
		launchPath = path
		arguments = args
	}
	
	var launchURL: URL { URL(fileURLWithPath: self.launchPath ?? "") }
	
	func run() async throws -> Data {
		let data: Data = try await withCheckedThrowingContinuation { continuation in
			let outputPipe = Pipe()
			let errorPipe = Pipe()
			
			self.standardOutput = outputPipe
			self.standardError = errorPipe
			
			do {
				try self.run()
				self.waitUntilExit()
				
				let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
				let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
				
				if !outputData.isEmpty {
					continuation.resume(returning: outputData)
				} else if !errorData.isEmpty {
					let errorString = String(data: errorData, encoding: .utf8) ?? "Error when running \(self.launchURL.lastPathComponent)"
					logg("Process failed: \(self.launchPath ?? "unknown command"), \(errorString)")
					continuation.resume(throwing: ProcessError.systemResult(errorString))
				} else {
					continuation.resume(returning: outputData)
				}
			} catch {
				continuation.resume(throwing: error)
			}
		}
		return data
	}
}
#endif
