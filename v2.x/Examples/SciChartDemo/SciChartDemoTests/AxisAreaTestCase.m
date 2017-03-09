//
//  AxisAreaTestCase.m
//  SciChartTesting
//
//  Created by Admin on 20.08.15.
//  Copyright (c) 2015 ABT. All rights reserved.
//

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
