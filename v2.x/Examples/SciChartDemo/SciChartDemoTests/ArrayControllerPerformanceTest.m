//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ArrayControllerPerformanceTest.m is part of the SCICHART® Examples. Permission is hereby granted
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

@interface ArrayControllerPerformanceTest : XCTestCase

@end

@implementation ArrayControllerPerformanceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testAppendGenericData {
    const int count = 10000000;
    ArrayController * array = [[ArrayController alloc] initWithType:DataType_Double Size:count];
    [self measureBlock:^{
        for (int i = 0; i < count; i++) {
            [array gAppend:Generic(i)];
//            [array append:i];
        }
        [array clear];
    }];
}

-(void) testGetGenericValue {
    const int count = 10000000;
    ArrayController * array = [[ArrayController alloc] initWithType:DataType_Double Size:count];
    for (int i = 0; i < count; i++) {
        [array gAppend:Generic(i)];
    }
    [self measureBlock:^{
        for (int i = 0; i < count; i++) {
//            [array valueAt:i];
            GenericDouble([array gValueAt:i]);
        }
    }];
}

-(void) testAppendGenericRange {
    const int count = 10000000;
    double data[count] = {};
    double * dataPtr = data;
    ArrayController * array = [[ArrayController alloc] initWithType:DataType_Double Size:count];
    [self measureBlock:^{
        [array gAppendRange:Generic(dataPtr) Count:count];
//        [array appendRange:dataPtr Count:count];
        [array clear];
    }];
}

@end
