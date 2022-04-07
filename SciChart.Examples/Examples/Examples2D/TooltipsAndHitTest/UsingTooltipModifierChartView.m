//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"

@implementation UsingTooltipModifierChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyDataSeries *dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries1.seriesName = @"Lissajous Curve";
    dataSeries1.acceptsUnsortedData = YES;
    SCIXyDataSeries *dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries2.seriesName = @"Sinewave";
    
    SCDDoubleSeries *doubleSeries1 = [SCDDataManager getLissajousCurveWithAlpha:0.8 beta:0.2 delta:0.43 count:500];
    SCDDoubleSeries *doubleSeries2 = [SCDDataManager getSinewaveWithAmplitude:1.5 Phase:1.0 PointCount:500];
    
    SCIDoubleValues *scaledValues = [SCDDataManager scaleValues:[SCDDataManager offset:doubleSeries1.xValues offset:1] scale:5];
    
    [dataSeries1 appendValuesX:scaledValues y:doubleSeries1.yValues];
    [dataSeries2 appendValuesX:doubleSeries2.xValues y:doubleSeries2.yValues];
    
    SCIEllipsePointMarker *pointMarker1 = [SCIEllipsePointMarker new];
    pointMarker1.strokeStyle = SCIPenStyle.TRANSPARENT;
    pointMarker1.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF4682B4];
    pointMarker1.size = CGSizeMake(5, 5);
    
    SCIFastLineRenderableSeries *line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = dataSeries1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4682B4 thickness:0.5];
    line1.pointMarker = pointMarker1;
    
    SCIEllipsePointMarker *pointMarker2 = [SCIEllipsePointMarker new];
    pointMarker2.strokeStyle = SCIPenStyle.TRANSPARENT;
    pointMarker2.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF3333];
    pointMarker2.size = CGSizeMake(5, 5);
    
    SCIFastLineRenderableSeries *line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = dataSeries2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF3333 thickness:0.5];
    line2.pointMarker = pointMarker2;

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.chartModifiers add:[SCITooltipModifier new]];
        
        [SCIAnimations sweepSeries:line1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:line2 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
