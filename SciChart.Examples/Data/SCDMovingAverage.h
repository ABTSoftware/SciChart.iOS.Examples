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

NS_ASSUME_NONNULL_BEGIN

@interface SCDMovingAverage : NSObject

@property (nonatomic, readonly) NSInteger length;

- (instancetype)initWithLength:(NSInteger)length;

- (SCDMovingAverage *)update:(double)value;

- (SCDMovingAverage *)push:(double)value;

- (double)current;

+ (SCIDoubleValues *)movingAverage:(SCIDoubleValues *)input period:(NSInteger)period;

+ (SCIDoubleValues *)rsi:(SCDPriceSeries *)input period:(NSInteger)period;
    
+ (SCDMacdPoints *)macd:(SCIDoubleValues *)input slow:(NSInteger)slow fast:(NSInteger)fast signal:(NSInteger)signal;

@end

NS_ASSUME_NONNULL_END
