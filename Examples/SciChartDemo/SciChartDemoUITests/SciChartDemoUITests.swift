//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SciChartDemoUITests.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import XCTest

class SciChartDemoUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testGenerateScreenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        snapshot("0-Launch", timeWaitingForIdle: 0)
        
        // Open 3D CHARTS
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"3D CHARTS").element.tap()

        // Uniform Mesh
        app.tables.staticTexts["Uniform Mesh Chart 3D"].tap()
        snapshot("1-Uniform-Mesh-3D", timeWaitingForIdle: 1)
        app.navigationBars["Uniform Mesh Chart 3D"].buttons["3D CHARTS"].tap()
        
        // Ellipsoid
        app.tables.staticTexts["Ellipsoid Free Surface Chart 3D"].tap()
        snapshot("2-Ellipsoid-3D", timeWaitingForIdle: 1)
        app.navigationBars["Ellipsoid Free Surface Chart 3D"].buttons["3D CHARTS"].tap()
        
        // Waterfall
        app.tables.staticTexts["Waterfall Chart 3D"].tap()
        app.children(matching: .window).element(boundBy: 0).swipeDown()
        snapshot("3-Waterfall-3D", timeWaitingForIdle: 1)
        app.navigationBars["Waterfall Chart 3D"].buttons["3D CHARTS"].tap()

        // Logarithmic Axis
        app.tables.staticTexts["Logarithmic Axis 3D"].tap()
        app.children(matching: .window).element(boundBy: 0).swipeDown()
        snapshot("4-Logarithmic-Axis-3D", timeWaitingForIdle: 1)
        app.navigationBars["Logarithmic Axis 3D"].buttons["3D CHARTS"].tap()

        // Back to MainMenu
        app.navigationBars["3D CHARTS"].buttons["icon"].tap()

        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "load")], timeout: 1)
        // Open 2D CHARTS
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"2D CHARTS").element.tap()
        
        // Candlestick
        app.tables.staticTexts["Candlestick Chart"].tap()
        snapshot("5-Candlestick", timeWaitingForIdle: 0)
        app.navigationBars["Candlestick Chart"].buttons["2D CHARTS"].tap()
        
        // Vertically Stacked Axes
        app.tables.staticTexts["Vertically Stacked Axes"].tap()
        snapshot("6-Vertically-Stacked-Axes", timeWaitingForIdle: 0)
        app.navigationBars["Vertically Stacked Axes"].buttons["2D CHARTS"].tap()
        
        // Scatter
        app.tables.staticTexts["Scatter Chart"].tap()
        snapshot("7-Scatter", timeWaitingForIdle: 0)
        app.navigationBars["Scatter Chart"].buttons["2D CHARTS"].tap()
        
        // Heatmap?
    }
}
