//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedColumnSideBySideChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "StackedColumnSideBySideChartView.h"
#import "SCDDataManager.h"
#import <SciChart/SCILabelProviderBase+Protected.h>

@interface YearsLabelProvider : SCILabelProviderBase
- (instancetype)init;
@end

@implementation YearsLabelProvider {
    NSArray *_xLabels;
}

- (instancetype)init {
    self = [super initWithAxisType:@protocol(ISCINumericAxis)];
    if (self) {
        _xLabels = [[NSMutableArray alloc] initWithObjects:@"2000", @"2010", @"2014", @"2050", nil];
    }
    return self;
}

- (id<ISCIString>)formatLabel:(id<ISCIComparable>)dataValue {
    int i = (int)dataValue.toDouble;
    NSString *result = @"";
    if (i >= 0 && i < 4) {
        result = _xLabels[i];
    }
    return result;
}

- (id<ISCIString>)formatCursorLabel:(id<ISCIComparable>)dataValue {
    int i = (int)dataValue.toDouble;
    NSString *result;
    if (i >= 0 && i < 4) {
        result = _xLabels[i];
    } else if (i < 0) {
        result = _xLabels[0];
    } else {
        result = _xLabels[3];
    }
    return result;
}

@end

@implementation StackedColumnSideBySideChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.autoTicks = NO;
    xAxis.majorDelta = @(1.0);
    xAxis.minorDelta = @(0.5);
    xAxis.drawMajorBands = YES;
    xAxis.labelProvider = [YearsLabelProvider new];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.drawMajorBands = YES;
    yAxis.axisTitle = @"billions of People";
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    yAxis.autoRange = SCIAutoRange_Always;
    
    double china[] = {1.269, 1.330, 1.356, 1.304};
    double india[] = {1.004, 1.173, 1.236, 1.656};
    double usa[] = {0.282, 0.310, 0.319, 0.439};
    double indonesia[] = {0.214, 0.243, 0.254, 0.313};
    double brazil[] = {0.176, 0.201, 0.203, 0.261};
    double pakistan[] = {0.146, 0.184, 0.196, 0.276};
    double nigeria[] = {0.123, 0.152, 0.177, 0.264};
    double bangladesh[] = {0.130, 0.156, 0.166, 0.234};
    double russia[] = {0.147, 0.139, 0.142, 0.109};
    double japan[] = {0.126, 0.127, 0.127, 0.094};
    double restOfTheWorld[] = {2.466, 2.829, 3.005, 4.306};
    
    SCIXyDataSeries *chinaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    chinaDataSeries.seriesName = @"China";
    SCIXyDataSeries *indiaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    indiaDataSeries.seriesName = @"India";
    SCIXyDataSeries *usaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    usaDataSeries.seriesName = @"USA";
    SCIXyDataSeries *indonesiaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    indonesiaDataSeries.seriesName = @"Indonesia";
    SCIXyDataSeries *brazilDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    brazilDataSeries.seriesName = @"Brazil";
    SCIXyDataSeries *pakistanDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    pakistanDataSeries.seriesName = @"Pakistan";
    SCIXyDataSeries *nigeriaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    nigeriaDataSeries.seriesName = @"Nigeria";
    SCIXyDataSeries *bangladeshDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    bangladeshDataSeries.seriesName = @"Bangladesh";
    SCIXyDataSeries *russiaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    russiaDataSeries.seriesName = @"Russia";
    SCIXyDataSeries *japanDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    japanDataSeries.seriesName = @"Japan";
    SCIXyDataSeries *restOfTheWorldDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    restOfTheWorldDataSeries.seriesName = @"Rest Of The World";
    SCIXyDataSeries *totalDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    totalDataSeries.seriesName = @"Total";

    for (int i = 0; i < 4; i++) {
        double xValue = i;
        [chinaDataSeries appendX:@(xValue) y:@(china[i])];
        if (i != 2) {
            [indiaDataSeries appendX:@(xValue) y:@(india[i])];
            [usaDataSeries appendX:@(xValue) y:@(usa[i])];
            [indonesiaDataSeries appendX:@(xValue) y:@(indonesia[i])];
            [brazilDataSeries appendX:@(xValue) y:@(brazil[i])];
        } else {
            [indiaDataSeries appendX:@(xValue) y:@(NAN)];
            [usaDataSeries appendX:@(xValue) y:@(NAN)];
            [indonesiaDataSeries appendX:@(xValue) y:@(NAN)];
            [brazilDataSeries appendX:@(xValue) y:@(NAN)];
        }
        [pakistanDataSeries appendX:@(xValue) y:@(pakistan[i])];
        [nigeriaDataSeries appendX:@(xValue) y:@(nigeria[i])];
        [bangladeshDataSeries appendX:@(xValue) y:@(bangladesh[i])];
        [russiaDataSeries appendX:@(xValue) y:@(russia[i])];
        [japanDataSeries appendX:@(xValue) y:@(japan[i])];
        [restOfTheWorldDataSeries appendX:@(xValue) y:@(restOfTheWorld[i])];
        [totalDataSeries appendX:@(xValue) y:@(china[i] + india[i] + usa[i] + indonesia[i] + brazil[i] + pakistan[i] + nigeria[i] + bangladesh[i] + russia[i] + japan[i] + restOfTheWorld[i])];
    }
    
    SCIHorizontallyStackedColumnsCollection *columnCollection = [SCIHorizontallyStackedColumnsCollection new];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:chinaDataSeries fillColor:0xff3399ff strokeColor:0xff2D68BC]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:indiaDataSeries fillColor:0xff014358 strokeColor:0xff013547]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:usaDataSeries fillColor:0xff1f8a71 strokeColor:0xff1B5D46]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:indonesiaDataSeries fillColor:0xffbdd63b strokeColor:0xff7E952B]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:brazilDataSeries fillColor:0xffffe00b strokeColor:0xffAA8F0B]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:pakistanDataSeries fillColor:0xfff27421 strokeColor:0xffA95419]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:nigeriaDataSeries fillColor:0xffbb0000 strokeColor:0xff840000]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:bangladeshDataSeries fillColor:0xff550033 strokeColor:0xff370018]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:russiaDataSeries fillColor:0xff339933 strokeColor:0xff2D732D]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:japanDataSeries fillColor:0xff00aba9 strokeColor:0xff006C6A]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:restOfTheWorldDataSeries fillColor:0xff560068 strokeColor:0xff3D0049]];
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.position = SCIAlignment_Top | SCIAlignment_Left;
    legendModifier.margins = (SCIEdgeInsets){.left = 10, .top = 10, .right = 10, .bottom = 10};
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnCollection];
        [self.surface.chartModifiers addAll:legendModifier, [SCITooltipModifier new], nil];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries fillColor:(uint)fillColor strokeColor:(uint)strokeColor {
    SCIStackedColumnRenderableSeries *rSeries = [SCIStackedColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:strokeColor thickness:1];
    
    [SCIAnimations waveSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
