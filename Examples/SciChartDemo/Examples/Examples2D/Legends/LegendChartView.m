//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LegendChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "LegendChartView.h"
#import "SCDDataManager.h"
#import <SciChart/SCIStyleBase+Protected.h>

#pragma mark - Selected Series Style

@interface CustomSeriesStyle : SCIStyleBase<id<ISCIRenderableSeries>>
@end
@implementation CustomSeriesStyle

- (instancetype)init {
    return [super initWithStyleableType:SCIRenderableSeriesBase.class];
}

- (void)applyStyleInternalTo:(id<ISCIRenderableSeries>)styleableObject {
    SCIPenStyle *currentPenStyle = styleableObject.strokeStyle;
    [self putProperty:@"Stroke" value:currentPenStyle intoObject:styleableObject];
    
    styleableObject.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:currentPenStyle.color thickness:4];
}

- (void)discardStyleInternalFrom:(id<ISCIRenderableSeries>)styleableObject {
    SCIPenStyle *penStyle = [self getValueFromProperty:@"Stroke" ofType:SCISolidPenStyle.class fromObject:styleableObject];
    styleableObject.strokeStyle = penStyle;
}

@end

#pragma mark - Chart Initialization

@implementation LegendChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    
    SCIXyDataSeries *dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries1.seriesName = @"Curve A";
    SCIXyDataSeries *dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries2.seriesName = @"Curve B";
    SCIXyDataSeries *dataSeries3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries3.seriesName = @"Curve C";
    SCIXyDataSeries *dataSeries4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries4.seriesName = @"Curve D";
    
    SCDDoubleSeries *doubleSeries1 = [SCDDataManager getStraightLinesWithGradient:4000 yIntercept:1.0 pointCount:10];
    SCDDoubleSeries *doubleSeries2 = [SCDDataManager getStraightLinesWithGradient:3000 yIntercept:1.0 pointCount:10];
    SCDDoubleSeries *doubleSeries3 = [SCDDataManager getStraightLinesWithGradient:2000 yIntercept:1.0 pointCount:10];
    SCDDoubleSeries *doubleSeries4 = [SCDDataManager getStraightLinesWithGradient:1000 yIntercept:1.0 pointCount:10];
    
    [dataSeries1 appendValuesX:doubleSeries1.xValues y:doubleSeries1.yValues];
    [dataSeries2 appendValuesX:doubleSeries2.xValues y:doubleSeries2.yValues];
    [dataSeries3 appendValuesX:doubleSeries3.xValues y:doubleSeries3.yValues];
    [dataSeries4 appendValuesX:doubleSeries4.xValues y:doubleSeries4.yValues];
    
    SCIFastLineRenderableSeries *line1 = [SCIFastLineRenderableSeries new];
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFF00 thickness:1];
    line1.dataSeries = dataSeries1;
    SCIFastLineRenderableSeries *line2 = [SCIFastLineRenderableSeries new];
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 thickness:1];
    line2.dataSeries = dataSeries2;
    SCIFastLineRenderableSeries *line3 = [SCIFastLineRenderableSeries new];
    line3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 thickness:1];
    line3.dataSeries = dataSeries3;
    SCIFastLineRenderableSeries *line4 = [SCIFastLineRenderableSeries new];
    line4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF1964FF thickness:1];
    line4.dataSeries = dataSeries4;
    line4.isVisible = NO;
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.margins = UIEdgeInsetsMake(16, 16, 16, 16);
    legendModifier.position = SCIAlignment_Top | SCIAlignment_Left;
    SCISeriesSelectionModifier *seriesSelectionModifier = [SCISeriesSelectionModifier new];
    seriesSelectionModifier.selectedSeriesStyle = [CustomSeriesStyle new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries addAll:line1, line2, line3, line4, nil];
        [self.surface.chartModifiers addAll:legendModifier, seriesSelectionModifier, nil];
        
        [SCIAnimations sweepSeries:line1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line2 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line3 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line4 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
