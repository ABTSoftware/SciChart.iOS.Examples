//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PointResamplerPerformanceTestCase.m is part of the SCICHART® Examples. Permission is hereby granted
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

@interface PointResamplerPerformanceTestCase : XCTestCase

@end

@implementation PointResamplerPerformanceTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceResampleWithoutReduction {
    const int size = 10000000;
    PointResampler *resampler = [[PointResampler alloc] init];
    ArrayController * xColumn = [[ArrayController alloc] initWithType:DataType_Float Size:size];
    ArrayController * yColumn = [[ArrayController alloc] initWithType:DataType_Float Size:size];
    IndexRange * pointRange = [[IndexRange alloc] initWithMin:Generic(0) Max:Generic(size-1)];
    for (int i = 0; i < size; i++) {
        [xColumn append:i];
        [yColumn append:i];
    }
    __block Point2DSeries * result = nil;
    
    [self measureBlock:^{
        result = [resampler executeMode:ResamplingMode_MinMax XColumn:xColumn YColumn:yColumn PointRange:pointRange VisibleRange:nil ViewPortWidth:100];
    }];
    XCTAssertNotEqual(result, nil);
}

@end
