//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LogarithmicAxisChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "LogarithmicAxisChartView.h"
#import "DataManager.h"

@implementation LogarithmicAxisChartView

- (void)initExample {
    SCILogarithmicNumericAxis * xAxis = [SCILogarithmicNumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.scientificNotation = SCIScientificNotation_LogarithmicBase;
    xAxis.textFormatting = @"#.#E+0";

    SCILogarithmicNumericAxis * yAxis = [SCILogarithmicNumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yAxis.scientificNotation = SCIScientificNotation_LogarithmicBase;
    yAxis.textFormatting = @"#.#E+0";
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries1.seriesName = @"Curve A";
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries2.seriesName = @"Curve B";
    SCIXyDataSeries * dataSeries3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries3.seriesName = @"Curve C";
    
    DoubleSeries * doubleSeries1 = [DataManager getExponentialCurveWithExponent:1.8 count:100];
    DoubleSeries * doubleSeries2 = [DataManager getExponentialCurveWithExponent:2.25 count:100];
    DoubleSeries * doubleSeries3 = [DataManager getExponentialCurveWithExponent:3.59 count:100];
    
    [dataSeries1 appendRangeX:doubleSeries1.xValues Y:doubleSeries1.yValues Count:doubleSeries1.size];
    [dataSeries2 appendRangeX:doubleSeries2.xValues Y:doubleSeries2.yValues Count:doubleSeries2.size];
    [dataSeries3 appendRangeX:doubleSeries3.xValues Y:doubleSeries3.yValues Count:doubleSeries3.size];

    uint line1Color = 0xFFFFFF00;
    uint line2Color = 0xFF279B27;
    uint line3Color = 0xFFFF1919;
    
    SCIFastLineRenderableSeries * line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = dataSeries1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line1Color withThickness:1.5];
    line1.pointMarker = [self getPointMarkerWithSize:5 colorCode:line1Color];

    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = dataSeries2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line2Color withThickness:1.5];
    line2.pointMarker = [self getPointMarkerWithSize:5 colorCode:line2Color];
    
    SCIFastLineRenderableSeries * line3 = [SCIFastLineRenderableSeries new];
    line3.dataSeries = dataSeries3;
    line3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line3Color withThickness:1.5];
    line3.pointMarker = [self getPointMarkerWithSize:5 colorCode:line3Color];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.renderableSeries add:line3];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line3 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCIEllipsePointMarker *)getPointMarkerWithSize:(int)size colorCode:(uint)colorCode {
    SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
    pointMarker.height = size;
    pointMarker.width = size;
    pointMarker.strokeStyle = nil;
    pointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:colorCode];
    
    return pointMarker;
}

@end
