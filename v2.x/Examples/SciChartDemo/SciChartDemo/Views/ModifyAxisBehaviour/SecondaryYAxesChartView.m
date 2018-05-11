//
//  SecondaryYAxesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "SecondaryYAxesChartView.h"
#import "DataManager.h"

@implementation SecondaryYAxesChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.axisTitle = @"Bottom Axis";
    
    id<SCIAxis2DProtocol> rightYAxis = [SCINumericAxis new];
    rightYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    rightYAxis.axisId = @"rightAxisId";
    rightYAxis.axisTitle = @"Right Axis";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
    
    id<SCIAxis2DProtocol> leftYAxis = [SCINumericAxis new];
    leftYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    leftYAxis.axisId = @"leftAxisId";
    leftYAxis.axisTitle = @"Left Axis";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;

    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];

    DoubleSeries * ds1Points = [DataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    DoubleSeries * ds2Points = [DataManager getDampedSinewaveWithAmplitude:3.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    
    [ds1 appendRangeX:ds1Points.xValues Y:ds1Points.yValues Count:ds1Points.size];
    [ds2 appendRangeX:ds2Points.xValues Y:ds2Points.yValues Count:ds2Points.size];
    
    SCIFastLineRenderableSeries * rs1 = [SCIFastLineRenderableSeries new];
    rs1.dataSeries = ds1;
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4083B7 withThickness:1.0];
    rs1.yAxisId = @"leftAxisId";
    
    SCIFastLineRenderableSeries * rs2 = [SCIFastLineRenderableSeries new];
    rs2.dataSeries = ds2;
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:2.0];
    rs2.yAxisId = @"rightAxisId";
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:leftYAxis];
        [self.surface.yAxes add:rightYAxis];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        
        [rs1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [rs2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
