//
//  DigitalLineChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//
#import <SciChart/SciChart.h>
#import "DigitalLineChartView.h"
#import "DataManager.h"

@implementation DigitalLineChartView

-(void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(1) Max:SCIGeneric(1.25)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.5) Max:SCIGeneric(0.5)];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(2.3) Max:SCIGeneric(3.3)];

    DoubleSeries * fourierSeries = [DataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [dataSeries appendRangeX:fourierSeries.xValues Y:fourierSeries.yValues Count:fourierSeries.size];
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:1.0];
    rSeries.isDigitalLine = YES;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [rSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
