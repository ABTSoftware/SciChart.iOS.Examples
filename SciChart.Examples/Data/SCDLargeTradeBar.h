//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDLargeTradeBar.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDLargeTrade.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDLargeTradeBar : NSObject

@property (strong, nonatomic, readonly) NSDate *date;
@property (strong, nonatomic, readonly) NSArray<SCDLargeTrade *> *largeTrades;

- (instancetype)initWithDate:(NSDate *)date andLargeTrades:(NSArray<SCDLargeTrade *> *)largeTrades;

@end

NS_ASSUME_NONNULL_END
