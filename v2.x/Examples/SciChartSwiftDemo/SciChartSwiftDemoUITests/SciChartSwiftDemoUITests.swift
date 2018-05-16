//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SciChartSwiftDemoUITests.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import XCTest

class SciChartSwiftDemoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpenLineChart() {
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Generates a Line-Chart in code."].tap()
        app.navigationBars["Line Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Legend Chart"].tap()
        app.statusBars.otherElements["Kyivstar network"].tap()
        tablesQuery.staticTexts["Digital Line Chart"].tap()
        app.navigationBars["Digital Line Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Column Chart"].tap()
        app.navigationBars["Column Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Mountain Chart"].tap()
        app.navigationBars["Mountain Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Digital Mountain Chart"].tap()
        app.navigationBars["Digital Mountain Chart"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        tablesQuery.staticTexts["Candlestick Chart"].tap()
        app.navigationBars["Candlestick Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Scatter Chart"].tap()
        app.navigationBars["Scatter Chart"].buttons["Root View Controller"].tap()
        
        let heatmapChartStaticText = tablesQuery.staticTexts["Heatmap Chart"]
        heatmapChartStaticText.tap()
        app.navigationBars["Heatmap Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Bubble Chart"].tap()
        app.navigationBars["Bubble Chart"].buttons["Root View Controller"].tap()
        heatmapChartStaticText.swipeUp()
        tablesQuery.cells.containing(.staticText, identifier:"Band Series Chart").children(matching: .staticText).matching(identifier: "Band Series Chart").element(boundBy: 0).tap()
        app.navigationBars["Band Series Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Digital Band Series Chart"].tap()
        app.navigationBars["Digital Band Series Chart"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        tablesQuery.staticTexts["Adding series with millions points Demo"].tap()
        app.navigationBars["Adding series with millions points Demo"].buttons["Back"].tap()
        tablesQuery.staticTexts["Impulse Chart"].tap()
        app.navigationBars["Impulse Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Error Bars Chart"].tap()
        app.navigationBars["Error Bars Chart"].buttons["Root View Controller"].tap()
        tablesQuery.staticTexts["Generates a Impulse-Chart in code."].swipeUp()
        tablesQuery.staticTexts["Fan Chart"].tap()
        app.navigationBars["Fan Chart"].buttons["Root View Controller"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Realtime Ticking Stock Chart").children(matching: .staticText).matching(identifier: "Realtime Ticking Stock Chart").element(boundBy: 0).tap()
        app.navigationBars["Realtime Ticking Stock Chart"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        tablesQuery.staticTexts["StackedMountain Chart"].tap()
        app.navigationBars["StackedMountain Chart"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        tablesQuery.staticTexts["Stacked Column Chart"].tap()
        app.navigationBars["Stacked Column Chart"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        tablesQuery.staticTexts["Stacked Column Side By Side"].tap()
        app.navigationBars["Stacked Column Side By Side"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()

        
  
        
    }
    
    
}
