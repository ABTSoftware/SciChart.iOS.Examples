#import <Foundation/Foundation.h>

typedef double(^DoubleFunc1)(double arg);

@interface ArrayUtil : NSObject

+ (double *)selectFrom:(double *)sourceArray to:(double *)destArray size:(int)size selector:(DoubleFunc1)selector;

@end
