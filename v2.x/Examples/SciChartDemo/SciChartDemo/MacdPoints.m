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
