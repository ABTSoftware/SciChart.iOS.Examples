//
//  DoubleSeries.m
//  SciChartDemo
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "DoubleSeries.h"

@implementation DoubleSeries {
    SCIArrayController *xArray;
    SCIArrayController *yArray;
}

- (SCIGenericType)xValues {
    SCIGenericType arrayPointer;
    arrayPointer.voidPtr = xArray.data;
    arrayPointer.type = SCIDataType_DoublePtr;
    
    return arrayPointer;
}

- (SCIGenericType)yValues {
    SCIGenericType arrayPointer;
    arrayPointer.voidPtr = yArray.data;
    arrayPointer.type = SCIDataType_DoublePtr;
    
    return arrayPointer;
}

- (int)size {
    return [xArray count];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        xArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
        yArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
    }
    return self;
}

- (instancetype)initWithCapacity: (int) capacity {
    self = [super init];
    if (self) {
        xArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
        yArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
    }
    return self;
}

- (void)addX: (double)x Y:(double)y {
    [xArray append:SCIGeneric(x)];
    [yArray append:SCIGeneric(y)];
}

@end
