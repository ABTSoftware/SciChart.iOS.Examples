//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedColumnChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "StackedColumnChartView.h"
#import "DataManager.h"

@implementation StackedColumnChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];

    double porkData[] = {10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11};
    double vealData[] = {12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10};
    double tomatoesData[] = {7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22};
    double cucumberData[] = {16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17};
    double pepperData[] = {7, 24, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16};

    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Pork Series";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Veal Series";
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds3.seriesName = @"Tomato Series";
    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds4.seriesName = @"Cucumber Series";
    SCIXyDataSeries * ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds5.seriesName = @"Pepper Series";
    
    int data = 1992;
    int size = sizeof(porkData) / sizeof(porkData[0]);
    for (int i = 0; i < size; i++) {
        double xValue = data + i;
        [ds1 appendX:SCIGeneric(xValue) Y:SCIGeneric(porkData[i])];
        [ds2 appendX:SCIGeneric(xValue) Y:SCIGeneric(vealData[i])];
        [ds3 appendX:SCIGeneric(xValue) Y:SCIGeneric(tomatoesData[i])];
        [ds4 appendX:SCIGeneric(xValue) Y:SCIGeneric(cucumberData[i])];
        [ds5 appendX:SCIGeneric(xValue) Y:SCIGeneric(pepperData[i])];
    }
    
    SCIVerticallyStackedColumnsCollection * verticalCollection1 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection1 add:[self getRenderableSeriesWithDataSeries:ds1 FillColor:0xff226fb7]];
    [verticalCollection1 add:[self getRenderableSeriesWithDataSeries:ds2 FillColor:0xffff9a2e]];

    SCIVerticallyStackedColumnsCollection * verticalCollection2 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds3 FillColor:0xffdc443f]];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds4 FillColor:0xffaad34f]];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds5 FillColor:0xff8562b4]];
    
    SCIHorizontallyStackedColumnsCollection * columnCollection = [SCIHorizontallyStackedColumnsCollection new];
    [columnCollection add:verticalCollection1];
    [columnCollection add:verticalCollection2];

    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnCollection];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIRolloverModifier new]]];
        
        [columnCollection addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries FillColor:(uint)fillColor {
    SCIStackedColumnRenderableSeries * renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.dataSeries = dataSeries;
    renderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.strokeStyle = nil;
    
    return renderableSeries;
}

@end
