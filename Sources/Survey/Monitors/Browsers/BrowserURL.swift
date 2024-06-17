//
//  BrowserURL.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Suite

public struct BrowserURL: Codable, Comparable, Equatable, CustomStringConvertible, Hashable, Identifiable {
	public let url: URL
	public let browser: BrowserKind
	public let title: String?
	public var id: String { url.absoluteString + "\(browser.rawValue)" }
	public static let ignoreThese: [String] = ["chrome://newtab/", "favorites://"]
  
	public func hash(into hasher: inout Hasher) {
		url.hash(into: &hasher)
		browser.hash(into: &hasher)
	}
	public var host: String? { url.host }
  
	public var description: String {
    "\(browser.abbreviation): \(host ?? url.absoluteString)"
  }

	public static func <(lhs: BrowserURL, rhs: BrowserURL) -> Bool {
    if lhs.browser != rhs.browser { return lhs.browser < rhs.browser }
    return lhs.url.absoluteString < rhs.url.absoluteString
  }
  
  init?(_ rawString: String, _ browser: BrowserKind) {
		if let url = URL(string: rawString.trimmingCharacters(in: .whitespacesAndNewlines)) {
			self.init(url, browser: browser, title: nil)
		}
		
		let chunks = rawString.components(separatedBy: ",")
		guard let last = chunks.last, let url = URL(string: last.trimmingCharacters(in: .whitespacesAndNewlines)) else { return nil }
		
		let title = chunks.dropLast().joined(separator: ",")
		self.init(url, browser: browser, title: title)
  }
  
	init?(_ url: URL?, browser: BrowserKind, title: String?) {
    self.browser = browser

    guard let url = url else {
      self.url = .blank
      return nil
    }
    
		self.title = title?.isEmpty == false ? title : nil
    self.url = url
		
		if Self.ignoreThese.contains(url.absoluteString) { return nil }
  }
}
