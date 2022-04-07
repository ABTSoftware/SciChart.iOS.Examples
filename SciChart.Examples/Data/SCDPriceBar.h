//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPriceBar.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>

@interface SCDPriceBar : NSObject

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSNumber *open;
@property (nonatomic, readonly) NSNumber *high;
@property (nonatomic, readonly) NSNumber *low;
@property (nonatomic, readonly) NSNumber *close;
@property (nonatomic, readonly) NSNumber *volume;

- (instancetype)initWithOpen:(NSNumber *)open high:(NSNumber *)high low:(NSNumber *)low close:(NSNumber *)close volume:(NSNumber *)volume;

- (instancetype)initWithDate:(NSDate *)date open:(NSNumber *)open high:(NSNumber *)high low:(NSNumber *)low close:(NSNumber *)close volume:(NSNumber *)volume;

@end
