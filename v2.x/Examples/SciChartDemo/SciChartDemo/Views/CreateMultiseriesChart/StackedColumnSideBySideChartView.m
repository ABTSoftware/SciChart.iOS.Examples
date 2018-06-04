//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import "DataManager.h"

@interface YearsLabelFormatter : NSObject<SCILabelFormatterProtocol>
@end

@implementation YearsLabelFormatter {
    NSArray * _xLabels;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _xLabels = [[NSMutableArray alloc] initWithObjects:@"2000", @"2010", @"2014", @"2050", nil];
    }
    return self;
}

- (void)updateWithAxis:(id<SCIAxis2DProtocol>)axis { }

- (NSAttributedString *)formatLabel:(SCIGenericType)dataValue {
    int i = (int)SCIGenericDouble(dataValue);
    NSString * result = @"";
    if (i >= 0 && i < 4) {
        result = _xLabels[i];
    }
    return [[NSMutableAttributedString alloc] initWithString:result];
}

- (NSAttributedString *)formatCursorLabel:(SCIGenericType)dataValue {
    int i = (int)SCIGenericDouble(dataValue);
    NSString * result;
    if (i >= 0 && i < 4) {
        result = _xLabels[i];
    } else if (i < 0) {
        result = _xLabels[0];
    } else {
        result = _xLabels[3];
    }
    return [[NSMutableAttributedString alloc] initWithString:result];
}

@end

@interface YearsLabelProvider : SCIFormatterLabelProviderBase
@end

@implementation YearsLabelProvider

- (instancetype)init {
    return [super initWithLabelFormatter:[YearsLabelFormatter new]];
}

@end

@implementation StackedColumnSideBySideChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoTicks = NO;
    xAxis.majorDelta = SCIGeneric(1.0);
    xAxis.minorDelta = SCIGeneric(0.5);
    xAxis.style.drawMajorBands = YES;
    xAxis.labelProvider = [YearsLabelProvider new];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.style.drawMajorBands = YES;
    yAxis.axisTitle = @"billions of People";
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.1)];
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
    
    SCIXyDataSeries * chinaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    chinaDataSeries.seriesName = @"China";
    SCIXyDataSeries * indiaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    indiaDataSeries.seriesName = @"India";
    SCIXyDataSeries * usaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    usaDataSeries.seriesName = @"USA";
    SCIXyDataSeries * indonesiaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    indonesiaDataSeries.seriesName = @"Indonesia";
    SCIXyDataSeries * brazilDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    brazilDataSeries.seriesName = @"Brazil";
    SCIXyDataSeries * pakistanDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    pakistanDataSeries.seriesName = @"Pakistan";
    SCIXyDataSeries * nigeriaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    nigeriaDataSeries.seriesName = @"Nigeria";
    SCIXyDataSeries * bangladeshDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    bangladeshDataSeries.seriesName = @"Bangladesh";
    SCIXyDataSeries * russiaDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    russiaDataSeries.seriesName = @"Russia";
    SCIXyDataSeries * japanDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    japanDataSeries.seriesName = @"Japan";
    SCIXyDataSeries * restOfTheWorldDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    restOfTheWorldDataSeries.seriesName = @"Rest Of The World";
    SCIXyDataSeries * totalDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    totalDataSeries.seriesName = @"Total";

    for (int i = 0; i < 4; i++) {
        double xValue = i;
        [chinaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(china[i])];
        if (i != 2) {
            [indiaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(india[i])];
            [usaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(usa[i])];
            [indonesiaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(indonesia[i])];
            [brazilDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(brazil[i])];
        } else {
            [indiaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(NAN)];
            [usaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(NAN)];
            [indonesiaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(NAN)];
            [brazilDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(NAN)];
        }
        [pakistanDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(pakistan[i])];
        [nigeriaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(nigeria[i])];
        [bangladeshDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(bangladesh[i])];
        [russiaDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(russia[i])];
        [japanDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(japan[i])];
        [restOfTheWorldDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(restOfTheWorld[i])];
        [totalDataSeries appendX:SCIGeneric(xValue) Y:SCIGeneric(china[i] + india[i] + usa[i] + indonesia[i] + brazil[i] + pakistan[i] + nigeria[i] + bangladesh[i] + russia[i] + japan[i] + restOfTheWorld[i])];
    }
    
    SCIHorizontallyStackedColumnsCollection * columnCollection = [SCIHorizontallyStackedColumnsCollection new];
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
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnCollection];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCILegendModifier new], [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIRolloverModifier new]]];
        
        [columnCollection addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries fillColor:(uint)fillColor strokeColor:(uint)strokeColor {
    SCIStackedColumnRenderableSeries * renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.dataSeries = dataSeries;
    renderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:strokeColor withThickness:1];
    
    return renderableSeries;
}

@end
