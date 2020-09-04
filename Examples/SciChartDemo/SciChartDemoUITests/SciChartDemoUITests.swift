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
    
    let timeWaitingFor2D = 5.0
    let timeWaitingFor3D = 2.5
    
    override func setUp() {
        // if (UIDevice.current.userInterfaceIdiom == .pad) {
        //     XCUIDevice.shared.orientation = .landscapeLeft
        // }
        
        continueAfterFailure = false
    }
    
    func testGenerateScreenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        snapshot("0-Launch", timeWaitingForIdle: 0)
        
        // Open FEATURED APPS
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"FEATURED APPS").element.tap()

        // LIDAR
        app.tables.staticTexts["LIDAR Point Cloud"].tap()
        let lidar = app.children(matching: .window).element(boundBy: 0)
        lidar.pinch(withScale: 1.7, velocity: 2)

        snapshot("1-Lidar-3D", timeWaitingForIdle: timeWaitingFor3D)
        app.navigationBars["LIDAR Point Cloud"].buttons["FEATURED APPS"].tap()
        
        // Back to MainMenu
        app.navigationBars["FEATURED APPS"].children(matching: .button).element(boundBy: 0).tap()

        // Open 3D CHARTS
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"3D CHARTS").element.tap()
        
        // Uniform Mesh
        app.tables.staticTexts["Uniform Mesh Chart 3D"].tap()
        snapshot("2-Uniform-Mesh-3D", timeWaitingForIdle: timeWaitingFor3D)
        app.navigationBars["Uniform Mesh Chart 3D"].buttons["3D CHARTS"].tap()
        
        // Ellipsoid
        app.tables.staticTexts["Ellipsoid Free Surface Chart 3D"].tap()
        snapshot("3-Ellipsoid-3D", timeWaitingForIdle: timeWaitingFor3D)
        app.navigationBars["Ellipsoid Free Surface Chart 3D"].buttons["3D CHARTS"].tap()
        
        // Waterfall
        app.tables.staticTexts["Waterfall Chart 3D"].tap()
        app.children(matching: .window).element(boundBy: 0).swipeDown()
        snapshot("4-Waterfall-3D", timeWaitingForIdle: timeWaitingFor3D)
        app.navigationBars["Waterfall Chart 3D"].buttons["3D CHARTS"].tap()
        
        // Logarithmic Axis
        app.tables.staticTexts["Logarithmic Axis 3D"].tap()
        app.children(matching: .window).element(boundBy: 0).swipeDown()
        snapshot("5-Logarithmic-Axis-3D", timeWaitingForIdle: timeWaitingFor3D)
        app.navigationBars["Logarithmic Axis 3D"].buttons["3D CHARTS"].tap()
        
        // Back to MainMenu
        app.navigationBars["3D CHARTS"].children(matching: .button).element(boundBy: 0).tap()
        
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "load")], timeout: 1)
        // Open 2D CHARTS
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"2D CHARTS").element.tap()
        
        // Candlestick
        app.tables.staticTexts["Candlestick Chart"].tap()
        snapshot("6-Candlestick", timeWaitingForIdle: timeWaitingFor2D)
        app.navigationBars["Candlestick Chart"].buttons["2D CHARTS"].tap()
        
        // Vertically Stacked Axes
        app.tables.staticTexts["Vertically Stacked Axes"].tap()
        snapshot("7-Vertically-Stacked-Axes", timeWaitingForIdle: timeWaitingFor2D)
        app.navigationBars["Vertically Stacked Axes"].buttons["2D CHARTS"].tap()
        
        // Scatter
        app.tables.staticTexts["Scatter Chart"].tap()
        snapshot("8-Scatter", timeWaitingForIdle: timeWaitingFor2D)
        app.navigationBars["Scatter Chart"].buttons["2D CHARTS"].tap()
        
        // Heatmap?
    }
}
