//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MovingAverage.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
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
