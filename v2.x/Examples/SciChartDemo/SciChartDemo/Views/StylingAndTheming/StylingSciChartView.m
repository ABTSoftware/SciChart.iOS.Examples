//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"

@implementation StylingSciChartView

- (void)initExample {
    // self.surface background. If you set color for chart area than it is color only for axes area
    self.surface.backgroundColor = UIColor.orangeColor;
    // chart area background fill color
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFB6C1];
    // chart area border color and thickness
    self.surface.renderableSeriesAreaBorder = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4682b4 withThickness:2];
    
    // Brushes and styles for the XAxis, vertical gridlines, vertical tick marks, vertical axis bands and xaxis labels
    SCISolidBrushStyle * xAxisGridBandBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
    SCISolidPenStyle * xAxisMajorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.greenColor withThickness:1];
    SCISolidPenStyle * xAxisMinorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.yellowColor withThickness:0.5 andStrokeDash:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    SCISolidPenStyle * xAxisMajorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.greenColor withThickness:1];
    SCISolidPenStyle * xAxisMinorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.yellowColor withThickness:0.5];
    UIColor * xAxisLabelColor = UIColor.purpleColor;
    NSString * xAxisFontName = @"Helvetica";
    float xAxisFontSize = 14.0f;
    BOOL xAxisDrawLabels = true;
    BOOL xAxisDrawMajorTicks = true;
    BOOL xAxisDrawMinorTicks = true;
    BOOL xAxisDrawMajorGridLines = true;
    BOOL xAxisDrawMinorGridLines = true;
    
    // Create the XAxis
    id <SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(150) Max:SCIGeneric(180)];
    
    // Apply styles to the XAxis (see above)
    xAxis.style.gridBandBrush = xAxisGridBandBrush;
    xAxis.style.majorGridLineBrush = xAxisMajorGridLineBrush;
    xAxis.style.minorGridLineBrush = xAxisMinorGridLineBrush;
    xAxis.style.labelStyle.color =  xAxisLabelColor;
    xAxis.style.labelStyle.fontName = xAxisFontName;
    xAxis.style.labelStyle.fontSize = xAxisFontSize;
    xAxis.style.drawMajorTicks = xAxisDrawMajorTicks;
    xAxis.style.drawMinorTicks = xAxisDrawMinorTicks;
    xAxis.style.drawLabels = xAxisDrawLabels;
    xAxis.style.drawMinorGridLines = xAxisDrawMinorGridLines;
    xAxis.style.drawMajorGridLines = xAxisDrawMajorGridLines;
    xAxis.style.majorTickSize = 5;
    xAxis.style.majorTickBrush = xAxisMajorTickBrush;
    xAxis.style.minorTickSize = 2;
    xAxis.style.minorTickBrush = xAxisMinorTickBrush;
    
    // Brushes and styles for the Right YAxis, vertical gridlines, vertical tick marks, horizontal axis bands and right yaxis labels
    SCISolidBrushStyle * yAxisGridBandBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
    SCISolidPenStyle * yAxisMajorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.greenColor withThickness:1];
    SCISolidPenStyle * yAxisMinorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.yellowColor withThickness:0.5 andStrokeDash:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    SCISolidPenStyle * yAxisMajorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.purpleColor withThickness:1];
    SCISolidPenStyle * yAxisMinorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.redColor withThickness:0.5];
    UIColor * yAxisLabelColor = UIColor.greenColor;
    NSString * yAxisFontName = @"Helvetica";
    float yAxisFontSize = 14.0f;
    BOOL yAxisDrawLabels = true;
    BOOL yAxisDrawMajorTicks = true;
    BOOL yAxisDrawMinorTicks = true;
    BOOL yAxisDrawMajorGridLines = true;
    BOOL yAxisDrawMinorGridLines = true;
    SCINumericLabelProvider * yAxisLabelFormatter = [ThousandsLabelProvider new]; // For more info see the LabelProvider API Documentation
    
    // Create the right YAxis
    id <SCIAxis2DProtocol> yRightAxis = [SCINumericAxis new];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    
    // Apply styles to the Right YAxis (see above)
    yRightAxis.style.gridBandBrush = yAxisGridBandBrush;
    yRightAxis.style.majorGridLineBrush = yAxisMajorGridLineBrush;
    yRightAxis.style.minorGridLineBrush = yAxisMinorGridLineBrush;
    yRightAxis.labelProvider = yAxisLabelFormatter;
    yRightAxis.style.labelStyle.color = yAxisLabelColor;
    yRightAxis.style.labelStyle.fontSize = yAxisFontSize;
    yRightAxis.style.labelStyle.fontName = yAxisFontName;
    yRightAxis.style.drawMajorTicks = yAxisDrawMajorTicks;
    yRightAxis.style.drawMinorTicks = yAxisDrawMinorTicks;
    yRightAxis.style.drawLabels = yAxisDrawLabels;
    yRightAxis.style.drawMinorGridLines = yAxisDrawMinorGridLines;
    yRightAxis.style.drawMajorGridLines = yAxisDrawMajorGridLines;
    yRightAxis.style.majorTickSize = 3;
    yRightAxis.style.majorTickBrush = yAxisMajorTickBrush;
    yRightAxis.style.minorTickSize = 2;
    yRightAxis.style.minorTickBrush = yAxisMinorTickBrush;
    
    // Brushes and styles for the Left YAxis, vertical gridlines, vertical tick marks, horizontal axis bands and left yaxis labels
    SCISolidPenStyle * yAxisLeftMajorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor  withThickness:1];
    SCISolidPenStyle * yAxisLeftMinorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor  withThickness:0.5];
    UIColor * yAxisLeftLabelColor = UIColor.purpleColor;
    float yAxisLeftFontSize = 12.0f;
    BOOL yAxisLeftDrawLabels = true;
    BOOL yAxisLeftDrawMajorTicks = true;
    BOOL yAxisLeftDrawMinorTicks = true;
    BOOL yAxisLeftDrawMajorGridLines = false;
    BOOL yAxisLeftDrawMinorGridLines = false;
    BOOL yAxisLeftDrawAxisBands = false;
    SCINumericLabelProvider * yAxisLeftLabelFormatter = [BillionsLabelProvider new]; // For more info see the LabelProvider API Documentation
    
    // Create the left YAxis
    id <SCIAxis2DProtocol> yLeftAxis = [SCINumericAxis new];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(3)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    
    // we are disabling bands and grid on secondary Y axis
    yLeftAxis.style.drawMajorBands = yAxisLeftDrawAxisBands;
    yLeftAxis.style.drawMajorGridLines = yAxisLeftDrawMajorGridLines;
    yLeftAxis.style.drawMinorGridLines = yAxisLeftDrawMinorGridLines;
    yLeftAxis.labelProvider = yAxisLeftLabelFormatter;
    yLeftAxis.style.labelStyle.color = yAxisLeftLabelColor;
    yLeftAxis.style.labelStyle.fontSize = yAxisLeftFontSize;
    yLeftAxis.style.drawLabels = yAxisLeftDrawLabels;
    yLeftAxis.style.drawMajorTicks = yAxisLeftDrawMajorTicks;
    yLeftAxis.style.drawMinorTicks = yAxisLeftDrawMinorTicks;
    yLeftAxis.style.drawMajorGridLines = yAxisLeftDrawMajorGridLines;
    yLeftAxis.style.drawMinorGridLines = yAxisLeftDrawMinorGridLines;
    yLeftAxis.style.majorTickSize = 3;
    yLeftAxis.style.majorTickBrush = yAxisLeftMajorTickBrush;
    yLeftAxis.style.minorTickSize = 2;
    yLeftAxis.style.minorTickBrush = yAxisLeftMinorTickBrush;
    
    // Create and populate data series
    PriceSeries * priceSeries = [DataManager getPriceDataIndu];
    double movingAverageArray[priceSeries.size];
    double offsetLowData[priceSeries.size];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    mountainDataSeries.seriesName = @"Mountain Series";
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    lineDataSeries.seriesName = @"Line Series";
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Int64];
    columnDataSeries.seriesName = @"Column Series";
    SCIOhlcDataSeries * candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    candlestickDataSeries.seriesName = @"Candlestick Series";
    
    [mountainDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble) Y:SCIGeneric([DataManager offsetArray:priceSeries.lowData destArray:offsetLowData count:priceSeries.size offset:-1000]) Count:priceSeries.size];
    SCIGenericType movingAverage = SCIGeneric([DataManager computeMovingAverageOf:priceSeries.closeData destArray:movingAverageArray sourceArraySize:priceSeries.size length:50]);
    [lineDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble) Y:movingAverage Count:priceSeries.size];
    [columnDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble) Y:SCIGeneric(priceSeries.volumeData) Count:priceSeries.size];
    [candlestickDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble)
                                   Open:SCIGeneric(priceSeries.openData)
                                   High:SCIGeneric(priceSeries.highData)
                                    Low:SCIGeneric(priceSeries.lowData)
                                  Close:SCIGeneric(priceSeries.closeData)
                                  Count:priceSeries.size];
    
    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.yAxisId = @"PrimaryAxisId";
    // mountain series area fill
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xA000D0D0];
    // mountain series line (just on top of mountain). If set to nil, there will be no line
    mountainSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00D0D0 withThickness:2];
    // setting to true gives jagged mountains. set to false if you want regular mountain chart
    mountainSeries.isDigitalLine = YES;
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    lineRenderableSeries.dataSeries = lineDataSeries;
    lineRenderableSeries.yAxisId = @"PrimaryAxisId";
    // line series color and thickness
    lineRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0000FF withThickness:3];
    // setting to true gives jagged line. set to false if you want regular line chart
    lineRenderableSeries.isDigitalLine = NO;
    // one of the options for point markers. That one uses core graphics drawing to render texture for point markers
    SCICoreGraphicsPointMarker * pointMarker = [[SCICoreGraphicsPointMarker alloc] init];
    pointMarker.height = 7;
    pointMarker.width = 7;
    // point marers at data points. set to nil if you don't need them
    lineRenderableSeries.pointMarker = pointMarker;
    
    SCIFastColumnRenderableSeries * columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = columnDataSeries;
    columnSeries.yAxisId = @"SecondaryAxisId";
    // column series fill color
    columnSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xE0D030D0];
    // column series outline color and width. It is set to nil to disable outline
    columnSeries.strokeStyle = nil;
    
    SCIFastCandlestickRenderableSeries * candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = candlestickDataSeries;
    candlestickSeries.yAxisId = @"PrimaryAxisId";
    // candlestick series has separate color for data where close is higher that open value (up) and oposite when close is lower than open (down)
    // candlestick stroke color and thicknes for "up" data
    candlestickSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 withThickness:1];
    // candlestick fill color for "up" data
    candlestickSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7000FF00];
    // candlestick stroke color and thicknes for "down" data
    candlestickSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 withThickness:1];
    // candlestick fill color for "down" data
    candlestickSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF0000];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yRightAxis];
        [self.surface.yAxes add:yLeftAxis];
    
        [self.surface.renderableSeries add:mountainSeries];
        [self.surface.renderableSeries add:lineRenderableSeries];
        [self.surface.renderableSeries add:columnSeries];
        [self.surface.renderableSeries add:candlestickSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCICursorModifier new], [SCIZoomExtentsModifier new]]];
        
        [mountainSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseOut]];
        [lineRenderableSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseOut]];
        [columnSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseOut]];
        [candlestickSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
    }];
}

@end
