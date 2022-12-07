//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSeriesChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ScatterSeriesChartView.h"
#import "SCDDataManager.h"

@implementation ScatterSeriesChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIRenderableSeries> rSeries1 = [self getScatterRenderableSeries:[SCITrianglePointMarker new] colorCode:0x77e97064 negative:NO];
    id<ISCIRenderableSeries> rSeries2 = [self getScatterRenderableSeries:[SCIEllipsePointMarker new] colorCode:0x77e8c667 negative:NO];
    id<ISCIRenderableSeries> rSeries3 = [self getScatterRenderableSeries:[SCITrianglePointMarker new] colorCode:0x77e97064 negative:YES];
    id<ISCIRenderableSeries> rSeries4 = [self getScatterRenderableSeries:[SCIEllipsePointMarker new] colorCode:0x77e8c667 negative:YES];
    
    SCIYAxisDragModifier *yAxisDragModifier = [SCIYAxisDragModifier new];
    yAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    SCICursorModifier *cursorModifier = [SCICursorModifier new];
    cursorModifier.receiveHandledEvents = YES;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.renderableSeries add:rSeries3];
        [self.surface.renderableSeries add:rSeries4];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCIPinchZoomModifier new], cursorModifier, [SCIXAxisDragModifier new], yAxisDragModifier, nil];
    }];
}

- (id<ISCIRenderableSeries>) getScatterRenderableSeries:(id<ISCIPointMarker>)pointMarker colorCode:(unsigned int)colorCode negative:(BOOL)negative {
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double];
    dataSeries.seriesName = ([pointMarker isKindOfClass:SCIEllipsePointMarker.class])
        ? negative ? @"Negative Ellipse" : @"Positive Ellipse"
        : negative ? @"Negative" : @"Positive";
    
    for (int i = 0; i < 200; i++) {
        double time = i < 100 ? randf(0, i + 10) / 100 : randf(0, 200 - i + 10) / 100;
        double y = negative ? -time * time * time : time * time * time;
        
        [dataSeries appendX:@(i) y:@(y)];
    }
    
    pointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:colorCode];
    pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF thickness:0.1];
    pointMarker.size = CGSizeMake(9, 9);
    
    SCIXyScatterRenderableSeries *rSeries = [SCIXyScatterRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.pointMarker = pointMarker;
    
    [SCIAnimations waveSeries:rSeries duration:2.0 delay:0.1 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
