//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedColumnFullFillChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "StackedColumnFullFillChartView.h"
#import "SCDDataManager.h"

@implementation StackedColumnFullFillChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
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
    
    SCIVerticallyStackedColumnsCollection *columnCollection = [SCIVerticallyStackedColumnsCollection new];
    columnCollection.isOneHundredPercent = YES;
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds1 fillColor:0xff274b92]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds2 fillColor:0xff274b92]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds3 fillColor:0xffae418d]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds4 fillColor:0xff68bcae]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds5 fillColor:0xff634e96]];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:[SCINumericAxis new]];
        [self.surface.yAxes add:[SCINumericAxis new]];
        [self.surface.renderableSeries add:columnCollection];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries fillColor:(unsigned int)fillColor {
    SCIStackedColumnRenderableSeries *rSeries = [SCIStackedColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:fillColor thickness:1.0];
    
    return rSeries;
}

@end
