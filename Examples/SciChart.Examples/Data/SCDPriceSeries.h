//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPriceSeries.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPriceBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDPriceSeries : NSObject

@property (nonatomic) NSInteger count;

- (instancetype)initWithCapacity:(NSInteger)capacity;

@property (nonatomic, readonly) SCIDateValues *dateData;

@property (nonatomic, readonly) SCIDoubleValues *openData;

@property (nonatomic, readonly) SCIDoubleValues *highData;

@property (nonatomic, readonly) SCIDoubleValues *lowData;

@property (nonatomic, readonly) SCIDoubleValues *closeData;

@property (nonatomic, readonly) SCILongValues *volumeData;

@property (nonatomic, readonly) SCIDoubleValues *indexesAsDouble;

- (void)add:(SCDPriceBar *)item;

- (SCDPriceBar *)itemAt:(NSInteger)index;

- (SCDPriceBar *)lastObject;

@end

NS_ASSUME_NONNULL_END
