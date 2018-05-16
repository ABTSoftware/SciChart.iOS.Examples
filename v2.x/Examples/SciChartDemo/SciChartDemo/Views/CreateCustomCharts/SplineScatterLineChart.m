//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "SplineLineRenderableSeries.h"

@implementation SplineScatterLineChart

-(void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.2) Max:SCIGeneric(0.2)];

    SCIXyDataSeries * originalData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    DoubleSeries * doubleSeries = [DataManager getSinewaveWithAmplitude:1.0 Phase:0.0 PointCount:28 Freq:7];
    [originalData appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.width = 7;
    ellipsePointMarker.height = 7;
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF006400 withThickness:1];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFFFFFFF];
    
    SplineLineRenderableSeries * splineRenderSeries = [SplineLineRenderableSeries new];
    splineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 withThickness:1.0];
    splineRenderSeries.dataSeries = originalData;
    splineRenderSeries.pointMarker = ellipsePointMarker;
    splineRenderSeries.upSampleFactor = 10;
    
    SCIFastLineRenderableSeries * lineRenderSeries = [SCIFastLineRenderableSeries new];
    lineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 withThickness:1.0];
    lineRenderSeries.dataSeries = originalData;
    lineRenderSeries.pointMarker = ellipsePointMarker;
  
    SCITextAnnotation * textAnnotation = [SCITextAnnotation new];
    textAnnotation.coordinateMode = SCIAnnotationCoordinate_Relative;
    textAnnotation.x1 = SCIGeneric(0.5);
    textAnnotation.y1 = SCIGeneric(0.01);
    textAnnotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    textAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    textAnnotation.style.textStyle.fontSize = 24;
    textAnnotation.text = @"Custom Spline Chart";
    textAnnotation.style.textColor = [UIColor whiteColor];
    textAnnotation.style.backgroundColor = [UIColor clearColor];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:splineRenderSeries];
        [self.surface.renderableSeries add:lineRenderSeries];
        [self.surface.annotations add:textAnnotation];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [splineRenderSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [lineRenderSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
