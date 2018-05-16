//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MountainChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "MountainChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "PriceSeries.h"

@implementation MountainChartView

-(void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCIDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    PriceSeries * priceData = [DataManager getPriceDataIndu];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    [dataSeries appendRangeX:SCIGeneric(priceData.dateData) Y:SCIGeneric(priceData.closeData) Count:priceData.size];
    
    SCIFastMountainRenderableSeries * rSeries = [[SCIFastMountainRenderableSeries alloc] init];
    rSeries.dataSeries = dataSeries;
    rSeries.zeroLineY = 10000;
    rSeries.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xAAFF8D42 finish:0x88090E11 direction:SCILinearGradientDirection_Vertical];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFFC9A8 withThickness:1.0];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCITooltipModifier new]]];
    }];
}

@end
