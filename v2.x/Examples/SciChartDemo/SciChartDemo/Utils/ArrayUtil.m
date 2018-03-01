#import "ArrayUtil.h"

@implementation ArrayUtil

+ (double *)selectFrom:(double *)sourceArray to:(double *)destArray size:(int)size selector:(DoubleFunc1)selector {
    for (int i = 0; i < size; i++) {
        destArray[i] = selector(sourceArray[i]);
    }
    
    return destArray;
}

@end
