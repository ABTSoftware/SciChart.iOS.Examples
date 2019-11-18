//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"
#import "SCDPriceSeries.h"

@implementation MountainChartView

- (void)initExample {
    id<ISCIAxis> xAxis = [SCIDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCDPriceSeries *priceData = [SCDDataManager getPriceDataIndu];
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    [dataSeries appendValuesX:priceData.dateData y:priceData.closeData];
    
    SCIFastMountainRenderableSeries *rSeries = [SCIFastMountainRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.zeroLineY = 10000;
    rSeries.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0, 1) startColorCode:0xAAFF8D42 endColorCode:0x88090E11];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFFC9A8 thickness:1.0];
    
    SCIXAxisDragModifier *xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier *yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:ExampleViewBase.createDefaultModifiers];
        
        [SCIAnimations sweepSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
