//
//  BubbleChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 18.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "BubbleChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "TradeData.h"

@implementation BubbleChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCIDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    
    SCIXyzDataSeries * dataSeries = [[SCIXyzDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double ZType:SCIDataType_Double];
    NSArray * tradeTicks = [DataManager getTradeTicks];
    for (int i = 0; i < tradeTicks.count; i++) {
        TradeData * tradeData = (TradeData *) tradeTicks[i];
        [dataSeries appendX:SCIGeneric(tradeData.tradeDate) Y:SCIGeneric(tradeData.tradePrice) Z:SCIGeneric(tradeData.tradeSize)];
    }
    
    SCIBubbleRenderableSeries * rSeries = [SCIBubbleRenderableSeries new];
    rSeries.bubbleBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x50CCCCCC];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFCCCCCC withThickness:1.0];
    rSeries.style.detalization = 44;
    rSeries.zScaleFactor = 1.0;
    rSeries.autoZRange = false;
    rSeries.dataSeries = dataSeries;

    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xffff3333 withThickness:2.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCITooltipModifier new]]];
        
        [rSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [lineSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
    }];
}

@end
