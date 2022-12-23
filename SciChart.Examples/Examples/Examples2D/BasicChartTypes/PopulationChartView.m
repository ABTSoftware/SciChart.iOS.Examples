//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2022. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PopulationChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "PopulationChartView.h"
#import "SCDDataManager.h"
#import "PopulationLabelProvider.h"
@implementation PopulationChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    xAxis.labelProvider = [[PopulationLabelProvider alloc] init];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;

    double mandata[] = {3,37,176,456,791,1342,1505,1706,2045,2264,2205,1978,2156,2216,2319,2251,2047,2042,2164,2069,1782};
    double womenData[] = {13,92,319,661,999,1534,1655,1814,2142,2353,2280,2012,2210,2257,2265,2127,1915,1930,2056,1963,1694};

    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Long yType:SCIDataType_Double];
    ds1.seriesName = @"Man";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Long yType:SCIDataType_Double];
    ds2.seriesName = @"Women";

    int size = sizeof(mandata) / sizeof(mandata[0]);
    int data = 0;

    //Age above 65
    for (int i = 0; i < size; i++) {
        double xValue = (i + data);
        if (i <= 7) {
            [ds1 appendX:@(xValue) y:@(mandata[i])];
            [ds2 appendX:@(xValue) y:@(womenData[i] * -1)];
        }
        else { break; }
    }
    SCIVerticallyStackedColumnsCollection *verticalCollection1 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection1 add:[self getRenderableSeriesWithDataSeries:ds1 FillColor:0xffc43360]];
    [verticalCollection1 add:[self getRenderableSeriesWithDataSeries:ds2 FillColor:0xffc43360]];


    //Age from 19 to 65
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Long yType:SCIDataType_Double];
    SCIXyDataSeries *ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Long yType:SCIDataType_Double];
    for (int i = 7; i < size; i++) {
        double xValue = (i + data);
        if (i <= 16) {
            [ds3 appendX:@(xValue) y:@(mandata[i])];
            [ds4 appendX:@(xValue) y:@(womenData[i] * -1)];
        }
        else { break; }
    }
    SCIVerticallyStackedColumnsCollection *verticalCollection2 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds3 FillColor:0xFF34c19c]];
    [verticalCollection2 add:[self getRenderableSeriesWithDataSeries:ds4 FillColor:0xFF34c19c]];

    //Age below 19
    SCIXyDataSeries *ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Long yType:SCIDataType_Double];
    SCIXyDataSeries *ds6 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Long yType:SCIDataType_Double];
    for (int i = 17; i < size; i++) {
        double xValue = (i + data);
        [ds5 appendX:@(xValue) y:@(mandata[i])];
        [ds6 appendX:@(xValue) y:@(womenData[i] * -1)];
    }
    SCIVerticallyStackedColumnsCollection *verticalCollection3 = [SCIVerticallyStackedColumnsCollection new];
    [verticalCollection3 add:[self getRenderableSeriesWithDataSeries:ds5 FillColor:0xffe8c667]];
    [verticalCollection3 add:[self getRenderableSeriesWithDataSeries:ds6 FillColor:0xffe8c667]];


    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:verticalCollection1];
        [self.surface.renderableSeries add:verticalCollection2];
        [self.surface.renderableSeries add:verticalCollection3];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], [SCIRolloverModifier new], nil];
    }];
}


- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries FillColor:(unsigned int)fillColor {
    SCIStackedColumnRenderableSeries *rSeries = [SCIStackedColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:fillColor thickness:0.5];

    [SCIAnimations waveSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];

    return rSeries;
}

@end

