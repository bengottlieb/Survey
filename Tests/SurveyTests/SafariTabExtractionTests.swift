//
//  TabExtractionTests.swift
//  
//
//  Created by Ben Gottlieb on 6/14/24.
//

import XCTest
import Survey

final class SafariTabExtractionTests: XCTestCase {
	func testFrontmostTab() throws {
		let frontTab = """
 {"Spectator-2024 - Cloud Firestore - Data - Firebase console", "https://console.firebase.google.com/u/0/project/spectator-2024/firestore/databases/-default-/data/~2Fusers~2FWvPqODwdzBNZGSxnPnnW9S9L6uz2~2Fdays~2F12-6-2024"}
 """
		let tabs = try AppleScript.TabFetcher.safariFrontmostTab.tabs(from: frontTab)
		
		XCTAssert(tabs.count == 1, "Expected 1 tab, got \(tabs)")
	}

	func testVisibleTabs() throws {
		let visibleTabs = """
 {{"Spectator-2024 - Cloud Firestore - Data - Firebase console", "Peter Friese's Blog", "thanospapazoglou/Pulse: ❤️ A heart rate camera pulse detector written in Swift."}, {"https://console.firebase.google.com/u/0/project/spectator-2024/firestore/databases/-default-/data/~2Fusers~2FWvPqODwdzBNZGSxnPnnW9S9L6uz2~2Fdays~2F12-6-2024", "https://peterfriese.dev/blog/2021/swiftui-list-item-bindings-behind-the-scenes/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS%2BDev%2BWeekly%2BIssue%2B512", "https://github.com/thanospapazoglou/Pulse"}}
 """
		let tabs = try AppleScript.TabFetcher.safariAllVisibleTabs.tabs(from: visibleTabs)
		
		XCTAssert(tabs.count == 3, "Expected three tabs, got \(tabs)")
	}

	func testFrontWindowTabs() throws {
		let allFrontTabs = """
 {{"Discover the top streamed music and songs online on Soundcloud", "Where to Store a Core Data Persistent Store", "SwiftUI: Animating Text Changes via Transitions - techjourney.me", "Quotas – App Engine – Habituation – Google Cloud console", "How to listen to remote changes in CloudKit CoreData | Swift Discovery", "Neal.fun", "DetectionTek | Trello", "Swift Codable: Decoding / Encoding With Context", "krzysztofzablocki/OhSnap: Reproduce bugs your user saw by capturing and replaying data snapshots with ease.", "Recents and Sharing – Figma", "Preventing Scroll Hijacking by DragGesture​Recognizer Inside ScrollView", "Syncing data with CloudKit in your iOS app using CKSyncEngine and Swift — Superwall", "Displaying live data with Live Activities | Apple Developer Documentation", "Boing Boing", "widget plist supports live activities - Google Search", "Displaying live data with Live Activities | by Abdur Rehman | Medium", "Swift AST Explorer", "Biden polls: Inflation is not the president’s problem.", "The Verge - All Posts", "Apple Intelligence: every new AI feature coming to the iPhone and Mac - The Verge", "Determine which swift version is a… | Apple Developer Forums", "firebase mac - Google Search", "Firebase console", "Spectator-2024 - Cloud Firestore - Data - Firebase console"}, {"https://soundcloud.com/discover", "https://cocoacasts.com/where-to-store-a-core-data-persistent-store#:~:text=With%20the%20introduction%20of%20the,a%20macOS%20application%20is%20organized.", "https://techjourney.me/index.php/2021/12/12/swiftui-animating-text-changes/", "https://console.cloud.google.com/appengine/quotadetails?authuser=0&project=habituation-2023&hl=en&pli=1", "https://onmyway133.com/posts/how-to-listen-to-remote-changes-in-cloudkit-coredata/", "https://neal.fun/", "https://trello.com/b/8hlyYRkf/detectiontek", "https://swiftrocks.com/swift-codable-decodingencoding-with-context", "https://github.com/krzysztofzablocki/OhSnap", "https://www.figma.com/files/recents-and-sharing/recently-viewed?fuid=1317898145806876182", "https://darjeelingsteve.com/articles/Preventing-Scroll-Hijacking-by-DragGestureRecognizer-Inside-ScrollView.html", "https://superwall.com/blog/syncing-data-with-cloudkit-in-your-ios-app-using-cksyncengine-and-swift-and-swiftui", "https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities", "https://feedly.com/i/subscription/feed%2Fhttp%3A%2F%2Fwww.boingboing.net%2Fatom.xml", "https://www.google.com/search?client=safari&rls=en&q=widget+plist+supports+live+activities&ie=UTF-8&oe=UTF-8", "https://medium.com/@mrchabd97/displaying-live-data-with-live-activities-edeaf2828535", "https://swift-ast-explorer.com/", "https://slate.com/news-and-politics/2024/06/biden-inflation-polls-pandemic-covid.html", "https://feedly.com/i/subscription/feed%2Fhttp%3A%2F%2Fwww.theverge.com%2Frss%2Findex.xml", "https://www.theverge.com/2024/6/10/24175405/wwdc-apple-ai-news-features-ios-18-macos-15-iphone-ipad-mac", "https://forums.developer.apple.com/forums/thread/714432", "https://www.google.com/search?client=safari&rls=en&q=firebase+mac&ie=UTF-8&oe=UTF-8#ip=1", "https://console.firebase.google.com/u/0/", "https://console.firebase.google.com/u/0/project/spectator-2024/firestore/databases/-default-/data/~2Fusers~2FWvPqODwdzBNZGSxnPnnW9S9L6uz2~2Fdays~2F12-6-2024"}}
"""
		let tabs = try AppleScript.TabFetcher.safariAllFrontWindowTabs.tabs(from: allFrontTabs)
		
		XCTAssert(tabs.count == 24, "Expected three 24, got \(tabs)")
	}

	func testAllTabs() throws {
		let allTabs = """
	{{{"Discover the top streamed music and songs online on Soundcloud", "Where to Store a Core Data Persistent Store", "SwiftUI: Animating Text Changes via Transitions - techjourney.me", "Quotas – App Engine – Habituation – Google Cloud console", "How to listen to remote changes in CloudKit CoreData | Swift Discovery", "Neal.fun", "DetectionTek | Trello", "Swift Codable: Decoding / Encoding With Context", "krzysztofzablocki/OhSnap: Reproduce bugs your user saw by capturing and replaying data snapshots with ease.", "Recents and Sharing – Figma", "Preventing Scroll Hijacking by DragGesture​Recognizer Inside ScrollView", "Syncing data with CloudKit in your iOS app using CKSyncEngine and Swift — Superwall", "Displaying live data with Live Activities | Apple Developer Documentation", "Boing Boing", "widget plist supports live activities - Google Search", "Displaying live data with Live Activities | by Abdur Rehman | Medium", "Swift AST Explorer", "Biden polls: Inflation is not the president’s problem.", "The Verge - All Posts", "Apple Intelligence: every new AI feature coming to the iPhone and Mac - The Verge", "Determine which swift version is a… | Apple Developer Forums", "firebase mac - Google Search", "Firebase console", "Spectator-2024 - Cloud Firestore - Data - Firebase console"}, {"Peter Friese's Blog", "Implementing custom popups in SwiftUI — Teletype", "iOS Code Review Newsletter | Curated code improvement tips", "ios - Is there any way to create/extract an array of Views using @ViewBuilder in SwiftUI - Stack Overflow", "Implementing custom popups in SwiftUI", "ViewExtractor/Sources/ViewExtractor/Extract.swift at main · GeorgeElsham/ViewExtractor", "timelines API methods - Mastodon documentation", "Midjourney for Product Design - Build Beautiful Apps with GPT-4 and Midjourney - Design+Code", "rryam/MusadoraKit: The ultimate companion to MusicKit.", "Exploring MusicKit and Apple Music API"}, {"thanospapazoglou/Pulse: ❤️ A heart rate camera pulse detector written in Swift.", "exyte/SVGView: SVG parser and renderer written in SwiftUI", "The Ringer Archives - The Rewatchables - Page 7", "‘Die Hard’ 30th Anniversary With Bill Simmons, Chris Ryan, Jason Concepcion, and Sean Fennessey - The Ringer", "NFT Widgets - Coinlytics - Confluence", "Meet AsyncSequence - WWDC21 - Videos - Apple Developer", "persistent.info: Infinite Mac: An Instant-Booting Quadra in Your Browser"}}, {{"https://soundcloud.com/discover", "https://cocoacasts.com/where-to-store-a-core-data-persistent-store#:~:text=With%20the%20introduction%20of%20the,a%20macOS%20application%20is%20organized.", "https://techjourney.me/index.php/2021/12/12/swiftui-animating-text-changes/", "https://console.cloud.google.com/appengine/quotadetails?authuser=0&project=habituation-2023&hl=en&pli=1", "https://onmyway133.com/posts/how-to-listen-to-remote-changes-in-cloudkit-coredata/", "https://neal.fun/", "https://trello.com/b/8hlyYRkf/detectiontek", "https://swiftrocks.com/swift-codable-decodingencoding-with-context", "https://github.com/krzysztofzablocki/OhSnap", "https://www.figma.com/files/recents-and-sharing/recently-viewed?fuid=1317898145806876182", "https://darjeelingsteve.com/articles/Preventing-Scroll-Hijacking-by-DragGestureRecognizer-Inside-ScrollView.html", "https://superwall.com/blog/syncing-data-with-cloudkit-in-your-ios-app-using-cksyncengine-and-swift-and-swiftui", "https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities", "https://feedly.com/i/subscription/feed%2Fhttp%3A%2F%2Fwww.boingboing.net%2Fatom.xml", "https://www.google.com/search?client=safari&rls=en&q=widget+plist+supports+live+activities&ie=UTF-8&oe=UTF-8", "https://medium.com/@mrchabd97/displaying-live-data-with-live-activities-edeaf2828535", "https://swift-ast-explorer.com/", "https://slate.com/news-and-politics/2024/06/biden-inflation-polls-pandemic-covid.html", "https://feedly.com/i/subscription/feed%2Fhttp%3A%2F%2Fwww.theverge.com%2Frss%2Findex.xml", "https://www.theverge.com/2024/6/10/24175405/wwdc-apple-ai-news-features-ios-18-macos-15-iphone-ipad-mac", "https://forums.developer.apple.com/forums/thread/714432", "https://www.google.com/search?client=safari&rls=en&q=firebase+mac&ie=UTF-8&oe=UTF-8#ip=1", "https://console.firebase.google.com/u/0/", "https://console.firebase.google.com/u/0/project/spectator-2024/firestore/databases/-default-/data/~2Fusers~2FWvPqODwdzBNZGSxnPnnW9S9L6uz2~2Fdays~2F12-6-2024"}, {"https://peterfriese.dev/blog/2021/swiftui-list-item-bindings-behind-the-scenes/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS%2BDev%2BWeekly%2BIssue%2B512", "https://blog.artemnovichkov.com/custom-popups-in-swiftui?utm_campaign=+SwiftUI+Weekly&utm_medium=email&utm_source=Revue+newsletter", "https://ioscodereview.com/", "https://stackoverflow.com/questions/62730374/is-there-any-way-to-create-extract-an-array-of-views-using-viewbuilder-in-swift", "https://www.artemnovichkov.com/blog/custom-popups-in-swiftui", "https://github.com/GeorgeElsham/ViewExtractor/blob/main/Sources/ViewExtractor/Extract.swift", "https://docs.joinmastodon.org/methods/timelines/#public", "https://designcode.io/gpt4-midjourney", "https://github.com/rryam/MusadoraKit", "https://rudrank.gumroad.com/l/musickit"}, {"https://github.com/thanospapazoglou/Pulse", "https://github.com/exyte/SVGView", "https://www.theringer.com/the-rewatchables/archives/7", "https://www.theringer.com/2018/8/1/17641364/die-hard-30th-anniversary-with-bill-simmons-chris-ryan-jason-concepcion-and-sean-fennessey", "https://cryptowidgets.atlassian.net/wiki/spaces/CRYPTOWIDG/pages/846168065/NFT+Widgets?src=mail", "https://developer.apple.com/videos/play/wwdc2021/10058/", "https://blog.persistent.info/2022/03/blog-post.html"}}}
	"""
		let tabs = try AppleScript.TabFetcher.safariAllTabs.tabs(from: allTabs)
		
		XCTAssert(tabs.count == 41, "Expected 41 tabs, got \(tabs)")
	}

}

/* 		Samples
 
 SCRIPT: All Tabs for Safari
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT: Current Tab for Safari
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT: All Visible Tabs for Safari
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT: All Front Tabs for Safari
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}
 
 
 
 
 
 SCRIPT: Frontmost Tab for Safari tell application "Safari" to get {name, URL} of current tab of front window
 

 SCRIPT: All Front Tabs for Safari tell application "Safari" to get {name, URL} of current tab of every window
 

 SCRIPT: All Visible Tabs for Safari tell application "Safari" to get {name, URL} of current tab of every window
 

 SCRIPT: All Tabs for Safari tell application "Safari" to get {name, URL} of every tab of every window
 

 */
