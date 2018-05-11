//
//  DoubleSeries.h
//  SciChartDemo
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface DoubleSeries : NSObject

@property(nonatomic, readonly) SCIGenericType xValues;

@property(nonatomic, readonly) SCIGenericType yValues;

@property(nonatomic, readonly) int size;

- (instancetype)initWithCapacity: (int) capacity;

- (void)addX: (double)x Y:(double)y;

- (void)clear;

- (SCIArrayController *)getXArray;

- (SCIArrayController *)getYArray;

@end
