//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "LineChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "SingleChartLayout.h"

@implementation LineChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];

    DoubleSeries * fourierSeries = [DataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [dataSeries appendRangeX:fourierSeries.xValues Y:fourierSeries.yValues Count:fourierSeries.size];

    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    rSeries.dataSeries = dataSeries;
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
    
        [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
