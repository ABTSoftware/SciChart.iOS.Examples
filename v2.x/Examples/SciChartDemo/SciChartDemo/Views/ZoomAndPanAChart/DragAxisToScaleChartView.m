//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DragAxisToScaleChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DragAxisToScaleChartView.h"
#import "DataManager.h"
#import "RandomWalkGenerator.h"

@implementation DragAxisToScaleChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(3) Max:SCIGeneric(6)];
    
    id<SCIAxis2DProtocol> rightYAxis = [SCINumericAxis new];
    rightYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    rightYAxis.axisId = @"RightAxisId";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
    
    id<SCIAxis2DProtocol> leftYAxis = [SCINumericAxis new];
    leftYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    leftYAxis.axisId = @"LeftAxisId";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;
    
    DoubleSeries * fourierSeries = [DataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    DoubleSeries * dampedSinewave = [DataManager getDampedSinewaveWithPad:1500 Amplitude:3.0 Phase:0.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    [mountainDataSeries appendRangeX:fourierSeries.xValues Y:fourierSeries.yValues Count:fourierSeries.size];
    [lineDataSeries appendRangeX:dampedSinewave.xValues Y:dampedSinewave.yValues Count:dampedSinewave.size];
    
    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x771964FF];
    mountainSeries.style.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0944CF withThickness:2.0];
    mountainSeries.yAxisId = @"LeftAxisId";
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:2.0];
    lineSeries.yAxisId = @"RightAxisId";
    
    SCIYAxisDragModifier * leftYAxisDM = [SCIYAxisDragModifier new];
    leftYAxisDM.axisId = @"LeftAxisId";
    
    SCIYAxisDragModifier * rightYAxisDM = [SCIYAxisDragModifier new];
    rightYAxisDM.axisId = @"RightAxisId";
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:leftYAxis];
        [self.surface.yAxes add:rightYAxis];
        [self.surface.renderableSeries add:mountainSeries];
        [self.surface.renderableSeries add:lineSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIXAxisDragModifier new], leftYAxisDM, rightYAxisDM, [SCIZoomExtentsModifier new]]];
        
        [mountainSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseInOut]];
        [lineSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseInOut]];
    }];
}

@end
