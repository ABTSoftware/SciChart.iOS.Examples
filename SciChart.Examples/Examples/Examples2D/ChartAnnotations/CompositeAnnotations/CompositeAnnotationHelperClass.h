//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CompositeAnnotationHelperClass.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface MeasureXAnnotation : SCICompositeAnnotation

@property (nonatomic, strong) SCILineAnnotation *line;
@property (nonatomic, strong) SCILineAnnotation *leftMarker;
@property (nonatomic, strong) SCILineAnnotation *rightMarker;
@property (nonatomic, strong) SCITextAnnotation *label;

- (void)updateMeasureWithXAxis:(id<ISCICoordinateCalculator>)xAxis
                isCategoryAxis:(BOOL)isCategoryAxis;

@end

@interface MeasureDragListener : NSObject <ISCIAnnotationDragListener>

@property (nonatomic, weak) MeasureXAnnotation *measure;
@property (nonatomic, weak) id<ISCIAxis> xAxis;

- (instancetype)initWithMeasure:(MeasureXAnnotation *)measure
                          xAxis:(id<ISCIAxis>)xAxis;

@end


#pragma mark - TradeInfoView

@interface TradeInfoView : SCIView

- (instancetype)initWithText:(NSString *)text;

@end

#pragma mark - TradeSetupAnnotation

@interface TradeSetupAnnotation : SCICompositeAnnotation

@property (nonatomic, strong) SCIImageAnnotation *entryIcon;
@property (nonatomic, strong) SCICustomAnnotation *infoView;
@property (nonatomic, strong) SCILineAnnotation *slLine;
@property (nonatomic, strong) SCILineAnnotation *tpLine;

- (instancetype)initWithEntry:(double)entry
                     stopLoss:(double)stopLoss
                   takeProfit:(double)takeProfit
                       xIndex:(double)xIndex
                        isBuy:(BOOL)isBuy;

@end
