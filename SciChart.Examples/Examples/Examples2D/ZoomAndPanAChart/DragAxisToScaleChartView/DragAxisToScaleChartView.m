//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"
#import "SCDRandomWalkGenerator.h"

@implementation DragAxisToScaleChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:3 max:6];
    
    id<ISCIAxis> rightYAxis = [SCINumericAxis new];
    rightYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    rightYAxis.axisId = @"RightAxisId";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF68bcae];
    rightYAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFF68bcae];
    
    id<ISCIAxis> leftYAxis = [SCINumericAxis new];
    leftYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    leftYAxis.axisId = @"LeftAxisId";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF68bcae];
    leftYAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFF68bcae];
    
    SCDDoubleSeries *fourierSeries = [SCDDataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    SCDDoubleSeries *dampedSinewave = [SCDDataManager getDampedSinewaveWithPad:1500 Amplitude:3.0 Phase:0.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    
    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    [mountainDataSeries appendValuesX:fourierSeries.xValues y:fourierSeries.yValues];
    [lineDataSeries appendValuesX:dampedSinewave.xValues y:dampedSinewave.yValues];
    
    SCIFastMountainRenderableSeries *mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7747bde6];
    mountainSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF47bde6 thickness:2.0];
    mountainSeries.yAxisId = @"LeftAxisId";
    
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:2.0];
    lineSeries.yAxisId = @"RightAxisId";
    
    self.xAxisDragModifier = [SCIXAxisDragModifier new];
    self.xAxisDragModifier.dragMode = self.selectedDragMode;
    self.xAxisDragModifier.isEnabled = self.selectedDirection == SCIDirection2D_XDirection || self.selectedDirection == SCIDirection2D_XyDirection;
    
    self.yAxisDragModifier = [SCIYAxisDragModifier new];
    self.yAxisDragModifier.dragMode = self.selectedDragMode;
    self.yAxisDragModifier.isEnabled = self.selectedDirection == SCIDirection2D_YDirection || self.selectedDirection == SCIDirection2D_XyDirection;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:leftYAxis];
        [self.surface.yAxes add:rightYAxis];
        [self.surface.renderableSeries add:mountainSeries];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.chartModifiers addAll:self.xAxisDragModifier, self.yAxisDragModifier, [SCIZoomExtentsModifier new], nil];
            
        [SCIAnimations sweepSeries:lineSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations scaleSeries:mountainSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
