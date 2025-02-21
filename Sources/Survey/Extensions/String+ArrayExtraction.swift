//
//  String+ArrayExtraction.swift
//  
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

extension String {
	var scriptedArrayElements: [String] {
		trimmingCharacters(in: .init(charactersIn: "{")).components(separatedBy: "\", \"").map { $0.trimmingCharacters(in: .init(charactersIn: "\" ")) }
	}
	
	var bracketize: String {
		var bracketed = replacingOccurrences(of: "{", with: "[").replacingOccurrences(of: "}", with: "]")
		
		let missingValue = "missing value"
		if bracketed.contains(missingValue) {
			//print("Found missing value!")
			guard let data = bracketed.data(using: .utf8) else { return "[]" }
			if (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)) == nil {
				bracketed = bracketed.replacingOccurrences(of: missingValue, with: "\"about.blank\"")
			}
		}
		return bracketed
	}
	
	var twoDArray: [[String]]? {
		guard let data = bracketize.data(using: .utf8) else { return nil }
		
		do {
			return try JSONDecoder().decode([[String]].self, from: data)
		} catch {
			SurveyLogger.error("Failed to decode a 2D string array: \(error, privacy: .public)")
			return nil
		}
	}
	
	var oneDArray: [String]? {
		guard let data = bracketize.data(using: .utf8) else { return nil }
		
		do {
			return try JSONDecoder().decode([String].self, from: data)
		} catch {
			SurveyLogger.error("Failed to decode a 1D string array: \(error, privacy: .public)")
			return nil
		}
	}
	
	var threeDArray: [[[String]]]? {
		guard let data = bracketize.data(using: .utf8) else { return nil }
		
		do {
			return try JSONDecoder().decode([[[String]]].self, from: data)
		} catch {
			SurveyLogger.error("Failed to decode a 3D string array: \(error, privacy: .public)")
			return nil
		}
	}
}
