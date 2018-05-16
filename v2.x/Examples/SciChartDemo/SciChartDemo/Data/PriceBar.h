//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PriceBar.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import <Foundation/Foundation.h>

@interface PriceBar : NSObject

@property(readonly, nonatomic) NSDate * date;
@property(readonly, nonatomic) double open;
@property(readonly, nonatomic) double high;
@property(readonly, nonatomic) double low;
@property(readonly, nonatomic) double close;
@property(readonly, nonatomic) long volume;

- (instancetype)initWithOpen:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume;

- (instancetype)initWithDate:(NSDate *)date open:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume;

@end
