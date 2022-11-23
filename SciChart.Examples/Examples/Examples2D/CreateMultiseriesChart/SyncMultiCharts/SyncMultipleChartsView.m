//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SyncMultipleChartsView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SyncMultipleChartsView.h"
#import "SCDDataManager.h"

static int const PointsCount = 500;

@implementation SyncMultipleChartsView {
    SCIDoubleRange *_sharedXRange;
    SCIDoubleRange *_sharedYRange;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    _sharedXRange = [[SCIDoubleRange alloc] initWithMin:0 max:1];
    _sharedYRange = [[SCIDoubleRange alloc] initWithMin:0 max:1];
    
    [self initChart:self.surface1];
    [self initChart:self.surface2];
}

- (void)initChart:(SCIChartSurface *)surface {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.visibleRange = _sharedXRange;
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.visibleRange = _sharedYRange;
    
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    for (int i = 0; i < PointsCount; i++) {
        [dataSeries appendX:@(i) y:@(PointsCount * sin(i * M_PI * 0.1) / i)];
    }
    
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1.0];
    
    SCIRolloverModifier *rolloverModifier = [SCIRolloverModifier new];
    rolloverModifier.receiveHandledEvents = YES;
    rolloverModifier.eventsGroupTag = @"SharedEventGroup";
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        [surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCIPinchZoomModifier new], rolloverModifier, [SCIXAxisDragModifier new], [SCIYAxisDragModifier new], nil];
        
        [surface zoomExtents];
        [SCIAnimations sweepSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
