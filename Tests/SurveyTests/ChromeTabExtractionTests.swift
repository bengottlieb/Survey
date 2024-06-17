//
//  ChromeTabExtractionTests.swift
//  
//
//  Created by Ben Gottlieb on 6/14/24.
//

import XCTest

final class ChromeTabExtractionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


/*			Samples
 
 
 SCRIPT: All Tabs for Chrome tell application "Google Chrome" to get (title, URL) of every tab of every window
 {{{"cnn - Google Search", "New Tab", "", "Page not found"}, {"The New York Times - Breaking News, US News, World News and Videos"}}, {{"https://www.google.com/search?q=cnn&oq=cnn&gs_lcrp=EgZjaHJvbWUqBwgAEAAYjwIyBwgAEAAYjwIyEwgBEC4YgwEYxwEYsQMY0QMYgAQyCggCEAAYsQMYgAQyCggDEAAYsQMYgAQyBwgEEAAYgAQyDQgFEAAYgwEYsQMYgAQyDQgGEAAYgwEYsQMYgAQyDQgHEAAYgwEYsQMYgAQyBwgIEAAYgATSAQc5ODRqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8", "chrome://newtab/", "https://macnn.com/", "https://www.teledyne-ml.com/Pages/PageNotFoundError.aspx?requestUrl=https://www.teledyne-ml.com/opacity.asp"}, {"https://www.nytimes.com/"}}}

 SCRIPT END -----------------------------
 SCRIPT: Frontmost Tab for Chrome tell application "Google Chrome" to get (title, URL) of active tab of front window
 {"Page not found", "https://www.teledyne-ml.com/Pages/PageNotFoundError.aspx?requestUrl=https://www.teledyne-ml.com/opacity.asp"}

 SCRIPT END -----------------------------
 SCRIPT: All Visible Tabs for Chrome tell application "Google Chrome" to get (title, URL) of active tab of every window
 {{"Page not found", "The New York Times - Breaking News, US News, World News and Videos"}, {"https://www.teledyne-ml.com/Pages/PageNotFoundError.aspx?requestUrl=https://www.teledyne-ml.com/opacity.asp", "https://www.nytimes.com/"}}

 SCRIPT END -----------------------------
 SCRIPT: All Front Tabs for Chrome tell application "Google Chrome" to get (title, URL) of every tab of front window
 {{"cnn - Google Search", "New Tab", "", "Page not found"}, {"https://www.google.com/search?q=cnn&oq=cnn&gs_lcrp=EgZjaHJvbWUqBwgAEAAYjwIyBwgAEAAYjwIyEwgBEC4YgwEYxwEYsQMY0QMYgAQyCggCEAAYsQMYgAQyCggDEAAYsQMYgAQyBwgEEAAYgAQyDQgFEAAYgwEYsQMYgAQyDQgGEAAYgwEYsQMYgAQyDQgHEAAYgwEYsQMYgAQyBwgIEAAYgATSAQc5ODRqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8", "chrome://newtab/", "https://macnn.com/", "https://www.teledyne-ml.com/Pages/PageNotFoundError.aspx?requestUrl=https://www.teledyne-ml.com/opacity.asp"}}

 SCRIPT END -----------------------------

 */
