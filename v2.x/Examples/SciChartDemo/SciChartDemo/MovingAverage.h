#import <Foundation/Foundation.h>
#import "PriceSeries.h"
#import "MacdPoints.h"

@interface MovingAverage : NSObject

- (instancetype)initWithLength:(int)length;

- (MovingAverage *)update:(double)value;

- (MovingAverage *)push:(double)value;

- (double)current;

- (int)length;

+ (double *)movingAverage:(double *)input output:(double *)output count:(int)count period:(int)period;

+ (double *)rsi:(PriceSeries *)input output:(double *)output count:(int)count period:(int)period;
    
+ (MacdPoints *)macd:(double *)input count:(int)count slow:(int)slow fast:(int)fast signal:(int)signal;

@end
