//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StylingSciChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "StylingSciChartView.h"
#import "SCDDataManager.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"

@implementation StylingSciChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    
    SCIFontDescriptor *tickFontDescriptor = [SCIFontDescriptor fontDescriptorWithName:@"Courier-Bold" size:14];
    SCIFontDescriptor *titleFontDescriptor =  [SCIFontDescriptor fontDescriptorWithName:@"Courier-Bold" size:18];
    
    // Create the XAxis
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:150 max:180];
    
    // Brushes and styles for the XAxis, vertical gridlines, vertical tick marks, vertical axis bands and xaxis labels
    xAxis.axisBandsStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
    xAxis.majorGridLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:1];
    xAxis.minorGridLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor thickness:0.5 strokeDashArray:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    
    xAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontDescriptor:tickFontDescriptor andTextColor:SCIColor.purpleColor];
    xAxis.titleStyle = [[SCIFontStyle alloc] initWithFontDescriptor:titleFontDescriptor andTextColor:SCIColor.purpleColor];
    xAxis.drawMajorTicks = YES;
    xAxis.drawMinorTicks = YES;
    xAxis.drawLabels = YES;
    xAxis.drawMinorGridLines = YES;
    xAxis.drawMajorGridLines = YES;
    xAxis.majorTickLineLength = 5;
    xAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:1];
    xAxis.minorTickLineLength = 2;
    xAxis.minorTickLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor thickness:0.5];
    
    // Create the right YAxis
    id<ISCIAxis> yRightAxis = [SCINumericAxis new];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    
    // Brushes and styles for the Right YAxis, vertical gridlines, vertical tick marks, horizontal axis bands and right yaxis labels
    yRightAxis.axisBandsStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
    yRightAxis.majorGridLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:1];
    yRightAxis.minorGridLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor thickness:0.5 strokeDashArray:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    yRightAxis.labelProvider = [ThousandsLabelProvider new]; // For more info see the LabelProvider API Documentation
    yRightAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontDescriptor:tickFontDescriptor andTextColor:SCIColor.greenColor];
    yRightAxis.titleStyle = [[SCIFontStyle alloc] initWithFontDescriptor:titleFontDescriptor andTextColor:SCIColor.greenColor];
    yRightAxis.drawMajorTicks = YES;
    yRightAxis.drawMinorTicks = YES;
    yRightAxis.drawLabels = YES;
    yRightAxis.drawMinorGridLines = YES;
    yRightAxis.drawMajorGridLines = YES;
    yRightAxis.majorTickLineLength = 3;
    yRightAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.purpleColor thickness:1];
    yRightAxis.minorTickLineLength = 2;
    yRightAxis.minorTickLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.redColor thickness:0.5];
    
    // Create the left YAxis
    id<ISCIAxis> yLeftAxis = [SCINumericAxis new];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0 max:3];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    
    // Brushes and styles for the Left YAxis, vertical gridlines, vertical tick marks, horizontal axis bands and left yaxis labels
    yLeftAxis.axisBandsStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
    yLeftAxis.majorGridLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:1];
    yLeftAxis.minorGridLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.yellowColor thickness:0.5 strokeDashArray:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    yLeftAxis.labelProvider = [BillionsLabelProvider new]; // For more info see the LabelProvider API Documentation
    yLeftAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontDescriptor:tickFontDescriptor andTextColor:SCIColor.purpleColor];
    yLeftAxis.titleStyle = [[SCIFontStyle alloc] initWithFontDescriptor:titleFontDescriptor andTextColor:SCIColor.purpleColor];
    yLeftAxis.drawLabels = YES;
    yLeftAxis.drawMajorTicks = YES;
    yLeftAxis.drawMinorTicks = YES;
    yLeftAxis.drawMajorGridLines = NO;
    yLeftAxis.drawMinorGridLines = NO;
    yLeftAxis.majorTickLineLength = 3;
    yLeftAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.blackColor  thickness:1];
    yLeftAxis.minorTickLineLength = 2;
    yLeftAxis.minorTickLineStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.blackColor  thickness:0.5];
    
    // Create and populate data series
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    
    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    mountainDataSeries.seriesName = @"Mountain Series";
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    lineDataSeries.seriesName = @"Line Series";
    SCIXyDataSeries *columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Long];
    columnDataSeries.seriesName = @"Column Series";
    SCIOhlcDataSeries *candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    candlestickDataSeries.seriesName = @"Candlestick Series";
    
    [mountainDataSeries appendValuesX:priceSeries.indexesAsDouble y:[SCDDataManager offset:priceSeries.lowData offset:-1000]];
    [lineDataSeries appendValuesX:priceSeries.indexesAsDouble y:[SCDDataManager computeMovingAverageOf:priceSeries.closeData length:50]];
    
    [columnDataSeries appendValuesX:priceSeries.indexesAsDouble y:priceSeries.volumeData];
    [candlestickDataSeries appendValuesX:priceSeries.indexesAsDouble open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastMountainRenderableSeries *mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.yAxisId = @"PrimaryAxisId";
    // mountain series area fill
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xA000D0D0];
    // mountain series line (just on top of mountain). If set to nil, there will be no line
    mountainSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00D0D0 thickness:2];
    // setting to true gives jagged mountains. set to false if you want regular mountain chart
    mountainSeries.isDigitalLine = YES;
    
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.yAxisId = @"PrimaryAxisId";
    // line series color and thickness
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0000FF thickness:3];
    // setting to true gives jagged line. set to false if you want regular line chart
    lineSeries.isDigitalLine = NO;
    // one of the options for point markers. That one uses core graphics drawing to render texture for point markers
    SCIEllipsePointMarker *pointMarker = [SCIEllipsePointMarker new];
    pointMarker.size = CGSizeMake(7, 7);
    // point marers at data points. set to nil if you don't need them
    lineSeries.pointMarker = pointMarker;
    
    SCIFastColumnRenderableSeries *columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = columnDataSeries;
    columnSeries.yAxisId = @"SecondaryAxisId";
    // column series fill color
    columnSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xE0D030D0];
    // column series outline color and width. It is set to nil to disable outline
    columnSeries.strokeStyle = SCIPenStyle.TRANSPARENT;
    
    SCIFastCandlestickRenderableSeries *candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = candlestickDataSeries;
    candlestickSeries.yAxisId = @"PrimaryAxisId";
    // candlestick series has separate color for data where close is higher that open value (up) and oposite when close is lower than open (down)
    // candlestick stroke color and thicknes for "up" data
    candlestickSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1];
    // candlestick fill color for "up" data
    candlestickSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x9068bcae];
    // candlestick stroke color and thicknes for "down" data
    candlestickSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFae418d thickness:1];
    // candlestick fill color for "down" data
    candlestickSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x90ae418d];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yRightAxis];
        [self.surface.yAxes add:yLeftAxis];
    
        [self.surface.renderableSeries add:mountainSeries];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:columnSeries];
        [self.surface.renderableSeries add:candlestickSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations scaleSeries:mountainSeries withZeroLine:10500 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:lineSeries withZeroLine:11700 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:columnSeries withZeroLine:12250 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:candlestickSeries withZeroLine:10500 duration:3.0 andEasingFunction:[SCIElasticEase new]];
    }];
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [super tryUpdateChartTheme:theme];
    
    // self.surface background. If you set color for chart area than it is color only for axes area
    self.surface.platformBackgroundColor = SCIColor.orangeColor;
    // chart area background fill color
    self.surface.renderableSeriesAreaFillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFB6C1];
    // chart area border color and thickness
    self.surface.renderableSeriesAreaBorderStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4682b4 thickness:2];
}

@end
