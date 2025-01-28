//
//  ANF_Code_TestUITests.swift
//  ANF Code TestUITests
//
//  Created by Justin Goulet on 1/28/25.
//

import XCTest

final class ANF_Code_TestUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    @MainActor
    func testShopMen() throws {
        let app = XCUIApplication()
        app.launch()
        app.tables.buttons["https://www.abercrombie.com/shop/us/mens-new-arrivals"].firstMatch.tap()
    }
    
    @MainActor
    func testShopWomen() throws {
        let app = XCUIApplication()
        app.launch()
        app.tables.buttons["https://www.abercrombie.com/shop/us/womens-new-arrivals"].firstMatch.tap()
    }

    @MainActor
    func testHyperlink() throws {
        let app = XCUIApplication()
        app.launch()
        app.tables.textViews["clickableLabel"].links.firstMatch.tap()
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
