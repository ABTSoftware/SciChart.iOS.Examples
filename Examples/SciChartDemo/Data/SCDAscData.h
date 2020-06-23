//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDAscData.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCDAscData : NSObject

@property (nonatomic, readonly) SCIIntegerValues *xValues;
@property (nonatomic, readonly) SCIDoubleValues *yValues;
@property (nonatomic, readonly) SCIIntegerValues *zValues;
@property (nonatomic, readonly) SCIUnsignedIntegerValues *colorValues;
@property (nonatomic, readonly) int cellSize;
@property (nonatomic, readonly) int xllCorner;
@property (nonatomic, readonly) int yllCorner;
@property (nonatomic, readonly) int numberColumns;
@property (nonatomic, readonly) int numberRows;
@property (nonatomic, readonly) int noDataValue;

- (instancetype)initWithRawData:(NSArray<NSString *> *)rawData;

- (SCIXyzDataSeries3D *)createXyzDataSeries;

- (SCIUniformGridDataSeries3D *)createUniformGridDataSeries;

- (SCIPointMetadataProvider3D *)createMetadataProviderWithColorMap:(SCIColorMap *)colorMap withinMin:(float)min andMax:(float)max;

@end

NS_ASSUME_NONNULL_END
