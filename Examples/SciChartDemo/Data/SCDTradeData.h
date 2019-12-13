//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDTradeData.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>

@interface SCDTradeData : NSObject

@property (nonatomic, readonly) NSDate *tradeDate;
@property (nonatomic, readonly) NSNumber *tradePrice;
@property (nonatomic, readonly) NSNumber *tradeSize;

- (instancetype)initWithTradeDate:(NSDate *)date tradePrice:(NSNumber *)price tradeSize:(NSNumber *)size;

@end
