//
//  StylingSciChart.m
//  SciChartDemo
//
//  Created by Admin on 13/09/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "StylingSciChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"

@implementation StylingSciChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc] initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:surface];
        
        NSDictionary *layout = @{@"SciChart": surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    [self setupSurface];
    [self setupAxes];
    [self setupRenderableSeries];
    [self setupModifiers];
}

-(void) setupSurface {
    // surface background. If you set color for chart area than it is color only for axes area
    surface.backgroundColor = UIColor.orangeColor;
    // chart area background fill color
    surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFB6C1];
    // chart area border color and thickness
    surface.renderableSeriesAreaBorder = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4682b4 withThickness:2];
}

-(void) setupAxes {
    
    
    // Brushes and styles for the XAxis, vertical gridlines, vertical tick marks, vertical axis bands and xaxis labels
    SCISolidBrushStyle * xAxisGridBandBrush =[[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
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
    id <SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
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
    SCISolidBrushStyle * yAxisGridBandBrush =[[SCISolidBrushStyle alloc] initWithColorCode:0x55ff6655];
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
    SCINumericLabelProvider * yAxisLabelFormatter = [[ThousandsLabelProvider alloc] init]; // For more info see the LabelProvider API Documentatino
    
    // Create the right YAxis
    id <SCIAxis2DProtocol> yRightAxis = [[SCINumericAxis alloc] init];
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
    SCINumericLabelProvider * yAxisLeftLabelFormatter = [[BillionsLabelProvider alloc] init]; // For more info see the LabelProvider API Documentatino
    
    // Create the left YAxis
    id <SCIAxis2DProtocol> yLeftAxis = [[SCINumericAxis alloc] init];
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
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yRightAxis];
    [surface.yAxes add:yLeftAxis];
}

-(void) setupRenderableSeries {
    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [mountainDataSeries setSeriesName:@"Mountain Series"];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [lineDataSeries setSeriesName:@"Line Series"];
    SCIXyDataSeries *columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [columnDataSeries setSeriesName:@"Column Series"];
    SCIOhlcDataSeries *candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [candlestickDataSeries setSeriesName:@"Candlestick Series"];
    
    SCDMovingAverage *averageHigh = [[SCDMovingAverage alloc] initWithLength:50];
    
    NSArray <SCDMultiPaneItem *> *dataSource = [DataManager loadThemeData];
    for (int i = 0; i < dataSource.count; i++) {
        SCDMultiPaneItem *item = dataSource[i];
        
        SCIGenericType xValue = SCIGeneric(i);
        SCIGenericType open = SCIGeneric(item.open);
        SCIGenericType high = SCIGeneric(item.high);
        SCIGenericType low = SCIGeneric(item.low);
        SCIGenericType close = SCIGeneric(item.close);
        
        [mountainDataSeries appendX:xValue Y:SCIGeneric(item.close - 1000)];
        [lineDataSeries appendX:xValue Y:SCIGeneric([averageHigh push:item.close].current)];
        [columnDataSeries appendX:xValue Y:SCIGeneric(item.volume)];
        [candlestickDataSeries appendX:xValue Open:open High:high Low:low Close:close];
    }
    
    SCIFastMountainRenderableSeries *mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.dataSeries = mountainDataSeries;
    mountainRenderableSeries.yAxisId = @"PrimaryAxisId";
    // mountain series area fill
    mountainRenderableSeries.style.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xA000D0D0];
    // mountain series line (just on top of mountain). If set to nil, there will be no line
    mountainRenderableSeries.style.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00D0D0 withThickness:2];
    // setting to true gives jagged mountains. set to false if you want regular mountain chart
    mountainRenderableSeries.isDigitalLine = YES;
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    lineRenderableSeries.dataSeries = lineDataSeries;
    lineRenderableSeries.yAxisId = @"PrimaryAxisId";
    // line series color and thickness
    lineRenderableSeries.style.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0000FF withThickness:3];
    // setting to true gives jagged line. set to false if you want regular line chart
    lineRenderableSeries.isDigitalLine = NO;
    // one of the options for point markers. That one uses core graphics drawing to render texture for point markers
    SCICoreGraphicsPointMarker* pointMarker = [[SCICoreGraphicsPointMarker alloc] init];
    pointMarker.height = 7;
    pointMarker.width = 7;
    // point marers at data points. set to nil if you don't need them
    lineRenderableSeries.style.pointMarker = pointMarker;
    
    SCIFastColumnRenderableSeries *columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.dataSeries = columnDataSeries;
    columnRenderableSeries.yAxisId = @"SecondaryAxisId";
    // column series fill color
    columnRenderableSeries.style.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xE0D030D0];
    // column series outline color and width. It is set to nil to disable outline
    columnRenderableSeries.style.strokeStyle = nil;

    SCIFastCandlestickRenderableSeries *candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    candlestickRenderableSeries.dataSeries = candlestickDataSeries;
    candlestickRenderableSeries.yAxisId = @"PrimaryAxisId";
    // candlestick series has separate color for data where close is higher that open value (up) and oposite when close is lower than open (down)
    // candlestick stroke color and thicknes for "up" data
    candlestickRenderableSeries.style.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 withThickness:1];
    // candlestick fill color for "up" data
    candlestickRenderableSeries.style.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7000FF00];
    // candlestick stroke color and thicknes for "down" data
    candlestickRenderableSeries.style.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 withThickness:1];
    // candlestick fill color for "down" data
    candlestickRenderableSeries.style.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF0000];
    
    [surface.renderableSeries add:mountainRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    [surface.renderableSeries add:columnRenderableSeries];
    [surface.renderableSeries add:candlestickRenderableSeries];
}

-(void) setupModifiers {
    SCICursorModifier *cursorModifier = [[SCICursorModifier alloc] init];
    cursorModifier.modifierName = @"Cursor Modifier";
    SCIZoomExtentsModifier *zoomExtentsModifier = [[SCIZoomExtentsModifier alloc] init];
    zoomExtentsModifier.modifierName = @"Zoom Extents Modifier";
    
    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[cursorModifier, zoomExtentsModifier]];
}

@end
