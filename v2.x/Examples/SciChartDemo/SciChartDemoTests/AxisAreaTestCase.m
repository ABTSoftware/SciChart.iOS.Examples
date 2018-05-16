//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AxisAreaTestCase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <SciChart/SciChart.h>

@interface AxisAreaTestCase : XCTestCase

@end

@implementation AxisAreaTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testAwakeFromNib {
    SciChartSurfaceView * parentView = [[NSBundle bundleWithIdentifier:@"Abt.Controls.SciChart"] loadNibNamed:@"SciChartSurfaceView" owner:self options:nil] [0];
    AxisArea * area = parentView.leftAxesArea;
    XCTAssertNotNil(area);
    NumericAxis * axis = [NumericAxis new];
    [area addItem:axis];
    XCTAssertEqual([area count], 1);
    id<IAxis> test = [area itemAt:0];
    XCTAssertEqual(test, axis);
    XCTAssertNotNil(axis);
}

@end
