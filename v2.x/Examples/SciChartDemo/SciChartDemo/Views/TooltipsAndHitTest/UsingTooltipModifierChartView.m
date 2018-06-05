//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingTooltipModifierChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingTooltipModifierChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation UsingTooltipModifierChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries1.seriesName = @"Lissajous Curve";
    dataSeries1.acceptUnsortedData = YES;
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries2.seriesName = @"Sinewave";
    
    DoubleSeries * doubleSeries1 = [DataManager getLissajousCurveWithAlpha:0.8 beta:0.2 delta:0.43 count:500];
    DoubleSeries * doubleSeries2 = [DataManager getSinewaveWithAmplitude:1.5 Phase:1.0 PointCount:500];
    
    [DataManager scaleValues:doubleSeries1.getXArray];
    [dataSeries1 appendRangeX:doubleSeries1.xValues Y:doubleSeries1.yValues Count:doubleSeries1.size];
    [dataSeries2 appendRangeX:doubleSeries2.xValues Y:doubleSeries2.yValues Count:doubleSeries2.size];
    
    SCIEllipsePointMarker * pointMarker1 = [SCIEllipsePointMarker new];
    pointMarker1.strokeStyle = nil;
    pointMarker1.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f green:130.f/255.f blue:180.f/255.f alpha:1.f]];
    pointMarker1.height = 5;
    pointMarker1.width = 5;
    
    SCIFastLineRenderableSeries * line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = dataSeries1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f green:130.f/255.f blue:180.f/255.f alpha:1.f] withThickness:0.5];
    line1.pointMarker = pointMarker1;
    
    SCIEllipsePointMarker * pointMarker2 = [SCIEllipsePointMarker new];
    pointMarker2.strokeStyle = nil;
    pointMarker2.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:255.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f]];
    pointMarker2.height = 5;
    pointMarker2.width = 5;
    
    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = dataSeries2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:255.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f] withThickness:0.5];
    line2.pointMarker = pointMarker2;
    
    SCITooltipModifier * toolTipModifier = [SCITooltipModifier new];
    toolTipModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.chartModifiers add:toolTipModifier];
        
        [line1 addAnimation:[[SCIFadeRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCIFadeRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
