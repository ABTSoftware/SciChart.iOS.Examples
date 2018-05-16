//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MacdPoints.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "MacdPoints.h"

@implementation MacdPoints {
    SCIArrayController * macdArray;
    SCIArrayController * signalArray;
    SCIArrayController * divergenceArray;
}

- (SCIGenericType)macdValues {
    SCIGenericType arrayPointer;
    arrayPointer.voidPtr = macdArray.data;
    arrayPointer.type = SCIDataType_DoublePtr;
    
    return arrayPointer;
}

- (SCIGenericType)signalValues {
    SCIGenericType arrayPointer;
    arrayPointer.voidPtr = signalArray.data;
    arrayPointer.type = SCIDataType_DoublePtr;
    
    return arrayPointer;
}

- (SCIGenericType)divergenceValues {
    SCIGenericType arrayPointer;
    arrayPointer.voidPtr = divergenceArray.data;
    arrayPointer.type = SCIDataType_DoublePtr;
    
    return arrayPointer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        macdArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
        signalArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
        divergenceArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double];
    }
    return self;
}

- (instancetype)initWithCapacity:(int)capacity {
    self = [super init];
    if (self) {
        macdArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
        signalArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
        divergenceArray = [[SCIArrayController alloc] initWithType:SCIDataType_Double Size:capacity];
    }
    return self;
}

- (void)addMacd:(double)macd signal:(double)signal divergence:(double)divergence {
    [macdArray append:SCIGeneric(macd)];
    [signalArray append:SCIGeneric(signal)];
    [divergenceArray append:SCIGeneric(divergence)];
}

@end
