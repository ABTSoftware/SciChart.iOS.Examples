//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VerticallyStackedYAxesView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "VerticallyStackedYAxesView.h"
#import "SCDDataManager.h"

#pragma mark - Vertically Stacked Axes Layout

@interface LeftAlignedOuterVerticallyStackedYAxisLayoutStrategy : SCIVerticalAxisLayoutStrategy
@end
@implementation LeftAlignedOuterVerticallyStackedYAxisLayoutStrategy

- (void)measureAxesWithAvailableWidth:(CGFloat)width height:(CGFloat)height andChartLayoutState:(SCIChartLayoutState *)chartLayoutState {
    for (NSUInteger i = 0, count = self.axes.count; i < count; i++) {
        id<ISCIAxis> axis = self.axes[i];
        [axis updateAxisMeasurements];
        
        CGFloat requiredAxisSize = [SCIVerticalAxisLayoutStrategy getRequiredAxisSizeFrom:axis.axisLayoutState];
        chartLayoutState.leftOuterAreaSize = MAX(requiredAxisSize, chartLayoutState.leftOuterAreaSize);
    }
}

- (void)layoutWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    NSUInteger count = self.axes.count;
    CGFloat height = bottom - top;
    CGFloat axisSize = height / count;
    
    CGFloat topPlacement = top;
    for (NSUInteger i = 0; i < count; i++) {
        id<ISCIAxis> axis = self.axes[i];
        SCIAxisLayoutState *axisLayoutState = axis.axisLayoutState;
        
        CGFloat bottomPlacement = topPlacement + axisSize;
        
        CGFloat requiredAxisSize = [SCIVerticalAxisLayoutStrategy getRequiredAxisSizeFrom:axisLayoutState];
        [axis layoutAreaWithLeft:right - requiredAxisSize + axisLayoutState.additionalLeftSize top:topPlacement right:right - axisLayoutState.additionalRightSize bottom:bottomPlacement];
        
        topPlacement = bottomPlacement;
    }
}

@end

#pragma mark - Chart Initialization

@implementation VerticallyStackedYAxesView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    NSMutableArray<id<ISCIXyDataSeries>> *dataSeries = [NSMutableArray<id<ISCIXyDataSeries>> new];
    for (int i = 0; i < 5; i++) {
        SCIXyDataSeries *ds = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
        [dataSeries addObject:ds];
        
        SCDDoubleSeries *sinewave = [SCDDataManager getSinewaveWithAmplitude:3 Phase:i PointCount:1000];
        [ds appendValuesX:sinewave.xValues y:sinewave.yValues];
    }
    
    SCIDefaultLayoutManager *layoutManager = [SCIDefaultLayoutManager new];
    layoutManager.leftOuterAxisLayoutStrategy = [LeftAlignedOuterVerticallyStackedYAxisLayoutStrategy new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.layoutManager = layoutManager;
        
        [self.surface.xAxes add:[SCINumericAxis new]];
        [self.surface.yAxes add:[self newAxisWithId:@"Ch0"]];
        [self.surface.yAxes add:[self newAxisWithId:@"Ch1"]];
        [self.surface.yAxes add:[self newAxisWithId:@"Ch2"]];
        [self.surface.yAxes add:[self newAxisWithId:@"Ch3"]];
        [self.surface.yAxes add:[self newAxisWithId:@"Ch4"]];
        
        [self.surface.renderableSeries add:[self newLineSeriesWithDataSeries:dataSeries[0] color:0xFFFF1919 andAxisId:@"Ch0"]];
        [self.surface.renderableSeries add:[self newLineSeriesWithDataSeries:dataSeries[1] color:0xFFFC9C29 andAxisId:@"Ch1"]];
        [self.surface.renderableSeries add:[self newLineSeriesWithDataSeries:dataSeries[2] color:0xFFFF1919 andAxisId:@"Ch2"]];
        [self.surface.renderableSeries add:[self newLineSeriesWithDataSeries:dataSeries[3] color:0xFFFC9C29 andAxisId:@"Ch3"]];
        [self.surface.renderableSeries add:[self newLineSeriesWithDataSeries:dataSeries[4] color:0xFF4083B7 andAxisId:@"Ch4"]];
        
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
    }];
    
    [self.surface zoomExtents];
}

- (SCIFastLineRenderableSeries *)newLineSeriesWithDataSeries:(id<ISCIXyDataSeries>)dataSeries color:(unsigned int)color andAxisId:(NSString *)axisId {
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:1];
    rSeries.yAxisId = axisId;
    
    [SCIAnimations sweepSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

- (id<ISCIAxis>)newAxisWithId:(NSString *)axisId {
    id<ISCIAxis> axis = [SCINumericAxis new];
    axis.axisAlignment = SCIAxisAlignment_Left;
    axis.axisId = axisId;
    axis.axisTitle = axisId;
    axis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-2 max:2];
    axis.autoRange = SCIAutoRange_Never;
    axis.drawMajorBands = NO;
    axis.drawMajorGridLines = NO;
    axis.drawMinorGridLines = NO;
    
    return axis;
}

@end
