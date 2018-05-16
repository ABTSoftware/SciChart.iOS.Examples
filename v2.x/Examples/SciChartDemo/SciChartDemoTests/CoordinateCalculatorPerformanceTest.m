//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CoordinateCalculatorPerformanceTest.m is part of the SCICHART® Examples. Permission is hereby granted
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
#import <float.h>

@interface CoordinateCalculatorPerformanceTest : XCTestCase

@end

@implementation CoordinateCalculatorPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetCoordinatesY {
    id<ICoordinateCalculator> coordCalc = [[DoubleCoordinateCalculator alloc] initWithDimension:150 Min:-5 Max:10 Direction:XYDirection_YDirection FlipCoordinates:NO];
    
    [self measureBlock:^{
        double total = 0;
        const int count = 10000000;
        for (int i = 0; i < count; i++) {
            total = total + [coordCalc getCoordinateFrom:10];
        }
    }];
    //        Assert.That(total, Is.EqualTo(0), "Control test. Result was wrong"); // Prevent optimization
}

- (void)testGetCoordinatesYUnsafe {
    id<ICoordinateCalculator> coordCalc = [[DoubleCoordinateCalculator alloc] initWithDimension:150 Min:-5 Max:10 Direction:XYDirection_YDirection FlipCoordinates:NO];
    
    [self measureBlock:^{
        double total = 0;
        const int count = 10000000;
        for (int i = 0; i < count; i++) {
            total += CoordinateCalculator_GetCoordinate ((__bridge void *)(coordCalc), 10);
        }
    }];
    //        Assert.That(total, Is.EqualTo(0), "Control test. Result was wrong"); // Prevent optimization
}

-(void) testGetCoordinatesXQuickly {
    id<ICoordinateCalculator> coordCalc = [[FlippedDoubleCoordinateCalculator alloc] initWithDimension:150 Min:-5 Max:10 Direction:XYDirection_XDirection FlipCoordinates:NO];
    
    [self measureBlock:^{
        double total = 0;
        const int count = 10000000;
        for (int i = 0; i < count; i++) {
            total += [coordCalc getCoordinateFrom:10];
        }
    }];
    //    Assert.That(total, Is.EqualTo(149E7), "Control test. Result was wrong"); // Prevent optimization
}

-(void) testGetCoordinatesXUnsafe {
    id<ICoordinateCalculator> coordCalc = [[FlippedDoubleCoordinateCalculator alloc] initWithDimension:150 Min:-5 Max:10 Direction:XYDirection_XDirection FlipCoordinates:NO];
    [self measureBlock:^{
        double total = 0;
        const int count = 10000000;
        for (int i = 0; i < count; i++) {
            total += FlippedCoordinateCalculator_GetCoordinate ((__bridge void *)(coordCalc), 10);
        }
    }];
    //    Assert.That(total, Is.EqualTo(149E7), "Control test. Result was wrong"); // Prevent optimization
}

@end
