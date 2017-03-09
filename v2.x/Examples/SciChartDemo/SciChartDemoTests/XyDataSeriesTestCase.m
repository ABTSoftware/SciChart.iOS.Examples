//
//  XyDataSeriesTestCase.m
//  SciChartTesting
//
//  Created by Admin on 17.09.15.
//  Copyright (c) 2015 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <SciChart/SciChart.h>

@interface XyDataSeriesTestCase : XCTestCase

@end

@implementation XyDataSeriesTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(NSArray*) getDateArrayWithStart:(NSDate*)startingDate Count:(int)count {
    NSMutableArray * dates = [NSMutableArray new];
    [dates addObject:startingDate];
    for (int i = 1; i < count; i++) {
        [dates addObject: [NSDate dateWithTimeInterval:i*3600*24 sinceDate:startingDate] ];
    }
    return dates;
}

-(void) testUpdateXYValues {
    const int count = 10;
    NSArray * dates = [self getDateArrayWithStart:[NSDate date] Count:count];
    double yValues[count] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    
    id<IDataDistributionCalculator> dataDstrCalc = [UserDefinedDistributionCalculator new];
    XyDataSeries *dataSeries = [[XyDataSeries alloc] initWithXType:DataType_DateTime YType:DataType_Double];
    dataSeries.dataDistributionCalculator = dataDstrCalc;
    [dataSeries appendRangeX:Generic(dates) Y:Generic((double *)yValues) Count:count];
    
    [dataSeries updateAt:count-1 Value:Generic(20)];
    yValues[9] = 20;
    
    XCTAssertTrue( [dataSeries hasValues] );
    XCTAssertEqual( [dataSeries count], count );
    XCTAssertEqual( [dataSeries.xValues count], count );
    XCTAssertEqual( [dataSeries.yValues count], count );
    for (int i = 0; i < count; i++) {
        NSDate * date; GetGenericData( [dataSeries.xValues gValueAt:i], date);
        XCTAssertEqual( [dates[i] compare:date], NSOrderedSame );
        double value; GetGenericData( [dataSeries.yValues gValueAt:i], value);
        XCTAssertEqual( value, yValues[i] );
    }
    XCTAssertEqual(GenericDouble([dataSeries YMax]), 20);
    XCTAssertEqual(GenericDouble([dataSeries YMin]), 1);
    
    [dataSeries updateAt:0 Value:Generic(-10)];
    yValues[0] = -10;
    
    XCTAssertEqual( [dataSeries count], count );
    XCTAssertEqual( [dataSeries.xValues count], count );
    XCTAssertEqual( [dataSeries.yValues count], count );
    for (int i = 0; i < count; i++) {
        NSDate * date; GetGenericData( [dataSeries.xValues gValueAt:i], date);
        XCTAssertEqual( [date compare:dates[i]], NSOrderedSame );
        double value; GetGenericData( [dataSeries.yValues gValueAt:i], value);
        XCTAssertEqual( value, yValues[i] );
    }
    XCTAssertEqual(GenericDouble([dataSeries YMax]), 20);
    XCTAssertEqual(GenericDouble([dataSeries YMin]), -10);
}

@end
