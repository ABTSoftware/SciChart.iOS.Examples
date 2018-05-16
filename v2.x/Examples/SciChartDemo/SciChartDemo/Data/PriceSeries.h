//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PriceSeries.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "PriceBar.h"

@interface PriceSeries : NSObject

- (instancetype)init;

- (double *)dateData;

- (double *)openData;

- (double *)highData;

- (double *)lowData;

- (double *)closeData;

- (long *)volumeData;

- (double *)indexesAsDouble;

- (void)add:(PriceBar *)item;

- (PriceBar *)itemAt:(int)index;

- (PriceBar *)lastObject;

- (int)size;

@end
