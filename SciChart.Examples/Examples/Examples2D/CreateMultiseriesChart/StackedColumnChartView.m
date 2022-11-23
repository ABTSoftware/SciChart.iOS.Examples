//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"

@implementation StackedColumnChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    id<ISCIAxis> yAxis = [SCINumericAxis new];

    double porkData[] = {10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11};
    double vealData[] = {12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10};
    double tomatoesData[] = {7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22};
    double cucumberData[] = {16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17};
    double pepperData[] = {7, 24, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16};

    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds1.seriesName = @"Pork Series";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds2.seriesName = @"Veal Series";
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds3.seriesName = @"Tomato Series";
    SCIXyDataSeries *ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds4.seriesName = @"Cucumber Series";
    SCIXyDataSeries *ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds5.seriesName = @"Pepper Series";
    
    int data = 1992;
    int size = sizeof(porkData) / sizeof(porkData[0]);
    for (int i = 0; i < size; i++) {
        double xValue = data + i;
        [ds1 appendX:@(xValue) y:@(porkData[i])];
        [ds2 appendX:@(xValue) y:@(vealData[i])];
        [ds3 appendX:@(xValue) y:@(tomatoesData[i])];
        [ds4 appendX:@(xValue) y:@(cucumberData[i])];
        [ds5 appendX:@(xValue) y:@(pepperData[i])];
    }
    
    SCIVerticallyStackedColumnsCollection *verticalCollection1 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection1 add:[self getRenderableSeriesWithDataSeries:ds1 FillColor:0xff274b92]];
    [verticalCollection1 add:[self getRenderableSeriesWithDataSeries:ds2 FillColor:0xffe97064]];

    SCIVerticallyStackedColumnsCollection *verticalCollection2 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds3 FillColor:0xffae418d]];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds4 FillColor:0xff68bcae]];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds5 FillColor:0xff634e96]];
    
    SCIHorizontallyStackedColumnsCollection *columnCollection = [SCIHorizontallyStackedColumnsCollection new];
    [columnCollection add:verticalCollection1];
    [columnCollection add:verticalCollection2];

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnCollection];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCIRolloverModifier new], nil];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries FillColor:(unsigned int)fillColor {
    SCIStackedColumnRenderableSeries *rSeries = [SCIStackedColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:fillColor thickness:1.0];
    
    [SCIAnimations waveSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
