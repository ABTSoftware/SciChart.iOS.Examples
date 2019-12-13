//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SplineScatterLineChart.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SplineScatterLineChart.h"
#import "SplineLineRenderableSeries.h"
#import "SCDDataManager.h"

@implementation SplineScatterLineChart

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];

    SCIXyDataSeries * originalData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCDDoubleSeries * doubleSeries = [SCDDataManager getSinewaveWithAmplitude:1.0 Phase:0.0 PointCount:28 Freq:7];
    [originalData appendValuesX:doubleSeries.xValues y:doubleSeries.yValues];
    
    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.size = CGSizeMake(7, 7);
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF006400 thickness:1];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFFFFFFF];
    
    SplineLineRenderableSeries *rSeries = [SplineLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF006400 thickness:2.0];
    rSeries.dataSeries = originalData;
    rSeries.pointMarker = ellipsePointMarker;
    rSeries.upSampleFactor = 10;
    
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 thickness:1.0];
    lineSeries.dataSeries = originalData;
    lineSeries.pointMarker = ellipsePointMarker;
  
    SCITextAnnotation *textAnnotation = [SCITextAnnotation new];
    textAnnotation.x1 = @(0.5);
    textAnnotation.y1 = @(0.01);
    textAnnotation.coordinateMode = SCIAnnotationCoordinateMode_Relative;
    textAnnotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    textAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    textAnnotation.text = @"Custom Spline Chart";
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.annotations add:textAnnotation];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCIPinchZoomModifier new], nil];
        
        [SCIAnimations scaleSeries:rSeries duration:2.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:lineSeries duration:2.0 andEasingFunction:[SCIElasticEase new]];
    }];
}

@end
