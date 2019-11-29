//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMovingAverage.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPriceSeries.h"
#import "SCDMacdPoints.h"

@interface SCDMovingAverage : NSObject

- (instancetype)initWithLength:(int)length;

- (SCDMovingAverage *)update:(double)value;

- (SCDMovingAverage *)push:(double)value;

- (double)current;

- (int)length;

+ (SCIDoubleValues *)movingAverage:(SCIDoubleValues *)input period:(int)period;

+ (SCIDoubleValues *)rsi:(SCDPriceSeries *)input period:(int)period;
    
+ (SCDMacdPoints *)macd:(SCIDoubleValues *)input slow:(int)slow fast:(int)fast signal:(int)signal;

@end
