//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SecondaryYAxesChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SecondaryYAxesChartView.h"
#import "SCDDataManager.h"

@implementation SecondaryYAxesChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.axisTitle = @"Bottom Axis";
    
    id<ISCIAxis> rightYAxis = [SCINumericAxis new];
    rightYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    rightYAxis.axisId = @"rightAxisId";
    rightYAxis.axisTitle = @"Right Axis";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF279B27];
    rightYAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFF279B27];
    
    id<ISCIAxis> leftYAxis = [SCINumericAxis new];
    leftYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    leftYAxis.axisId = @"leftAxisId";
    leftYAxis.axisTitle = @"Left Axis";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF4083B7];
    leftYAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFF4083B7];

    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];

    SCDDoubleSeries *ds1Points = [SCDDataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    SCDDoubleSeries *ds2Points = [SCDDataManager getDampedSinewaveWithAmplitude:3.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    
    [ds1 appendValuesX:ds1Points.xValues y:ds1Points.yValues];
    [ds2 appendValuesX:ds2Points.xValues y:ds2Points.yValues];
    
    SCIFastLineRenderableSeries *rs1 = [SCIFastLineRenderableSeries new];
    rs1.dataSeries = ds1;
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4083B7 thickness:1.0];
    rs1.yAxisId = @"leftAxisId";
    
    SCIFastLineRenderableSeries *rs2 = [SCIFastLineRenderableSeries new];
    rs2.dataSeries = ds2;
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 thickness:2.0];
    rs2.yAxisId = @"rightAxisId";
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:leftYAxis];
        [self.surface.yAxes add:rightYAxis];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        [self.surface.chartModifiers add:ExampleViewBase.createDefaultModifiers];
        
        [SCIAnimations sweepSeries:rs1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:rs2 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
