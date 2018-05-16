//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DoubleSeries.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DoubleSeries.h"

@implementation DoubleSeries {
    SCIArrayController * xArray;
    SCIArrayController * yArray;
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

- (instancetype)init {
    self = [super init];
    if (self) {
        xArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
        yArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
    }
    return self;
}

- (instancetype)initWithCapacity:(int)capacity {
    self = [super init];
    if (self) {
        xArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
        yArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
    }
    return self;
}

- (void)addX:(double)x Y:(double)y {
    [xArray append:SCIGeneric(x)];
    [yArray append:SCIGeneric(y)];
}

- (void)clear {
    [xArray purge];
    [yArray purge];
}

- (SCIArrayController *)getXArray {
    return xArray;
}

- (SCIArrayController *)getYArray {
    return yArray;
}

@end
