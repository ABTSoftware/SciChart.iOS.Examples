//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SciChartDemoUITests.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <XCTest/XCTest.h>
#import <SciChart/SciChart.h>

@interface SciChartDemoUITests : XCTestCase

@end

@implementation SciChartDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *navigationBar = app.navigationBars[@"SciChart iOS BETA"];
    
//    if(navigationBar.buttons[@"Skip"]){
//        [navigationBar.buttons[@"Skip"] tap];
//    }
//    
    [app.tables.staticTexts[@"Line Chart"] tap];
//
//    
//    XCTAssertEqual(app.navigationBars.element.placeholderValue, @"SciChart iOS | Line Chart");
//    SCIChartSurface *surfaceView = [[XCUIElement alloc]init].otherElements
    
}

@end
