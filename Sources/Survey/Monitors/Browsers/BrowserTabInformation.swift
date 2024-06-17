//
//  BrowserTabInformation.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/14/24.
//

import Foundation
import Suite

public struct BrowserTabInformation: Codable, Hashable, Equatable {
	public let url: URL
	public let title: String?
	public let browser: BrowserKind
}

enum BrowserTabInformationError: Error {
	case incorrectDataFormat
	case missingNameOrURLComponents
	case urlNameCountMismatch
	case unableToExtract2DStringArray
	case unableToExtract3DStringArray
	case incorrectNumberOfTabComponents
}

extension BrowserTabInformation {
	static let ignoredURLs: [URL] = [
		URL(string: "chrome://settings/")!,
		URL(string: "chrome://newtab/")!,
		URL(string: "favorites://")!,
		URL(string: "chrome://startpageshared/")!,
	]
}

extension [BrowserTabInformation] {
	func contains(_ url: URL) -> Bool {
		contains { $0.url == url }
	}

	var names: String {
		compactMap { $0.title }.joined(separator: ", ")
	}
	
	init(namesAndURLsByWindow raw: String, browser: BrowserKind, ignoring: [URL] = BrowserTabInformation.ignoredURLs) throws {
		guard let arrays = raw.threeDArray else { throw BrowserTabInformationError.unableToExtract3DStringArray }
		var tabs: [BrowserTabInformation] = []
		
		if arrays.count != 2 {
			throw BrowserTabInformationError.missingNameOrURLComponents
		}
		
		let allNames = arrays[0]
		let allUrls = arrays[1]
		
		if allNames.count != allUrls.count { throw BrowserTabInformationError.urlNameCountMismatch }
		
		for (names, urls) in zip(allNames, allUrls) {
			if names.count != urls.count { throw BrowserTabInformationError.urlNameCountMismatch }
			tabs += zip(names, urls).compactMap { name, raw in
				guard let url = URL(string: raw), !ignoring.contains(url) else { return nil }
				return BrowserTabInformation(url: url, title: name, browser: browser)
			}
		}
		
		self = tabs
	}
	
	init(namesAndURLs raw: String, browser: BrowserKind, ignoring: [URL] = BrowserTabInformation.ignoredURLs) throws {
		guard let arrays = raw.twoDArray else { throw BrowserTabInformationError.unableToExtract2DStringArray }
		let names = arrays[0]
		let urls = arrays[1]
		
		if names.count != urls.count { throw BrowserTabInformationError.urlNameCountMismatch }
		
		self = zip(names, urls).compactMap { name, raw in
			guard let url = URL(string: raw), !ignoring.contains(url) else { return nil }
			return BrowserTabInformation(url: url, title: name, browser: browser)
		}
	}
	
	init(tabNameAndURL raw: String, browser: BrowserKind, ignoring: [URL] = BrowserTabInformation.ignoredURLs) throws {
		guard let parts = raw.oneDArray else { throw BrowserTabInformationError.incorrectDataFormat }
		
		if parts.count != 2 { throw BrowserTabInformationError.incorrectNumberOfTabComponents }
		
		if let url = URL(string: parts[0]), !ignoring.contains(url) {
			self = [BrowserTabInformation(url: url, title: parts[1], browser: browser)]
		} else {
			self = []
		}
	}
}

