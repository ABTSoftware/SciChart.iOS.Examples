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
    // surface background. If you set colot for chart area than it is color only for axes area
    surface.backgroundColor = UIColor.whiteColor;
    // chart area background fill color
    surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColor:UIColor.lightGrayColor];
    // chart area border color and thicknes
    surface.renderableSeriesAreaBorder = [[SCISolidPenStyle alloc] initWithColor:UIColor.darkGrayColor withThickness:1];
}

-(void) setupAxes {
    id <SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(150) Max:SCIGeneric(180)];
    // setting axis band color. Band is filled area between major grid lines
    xAxis.style.gridBandBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x70000000];
    // changing major grid line color and thicknes. major grid line is line at the label position
    xAxis.style.majorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:1];
    // changing minor grid line color and thicknes. minor grid lines are located between major grid lines
    xAxis.style.minorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:0.5];
    // axis label color
    xAxis.style.labelStyle.color = UIColor.darkGrayColor;
    // axis label font
    xAxis.style.labelStyle.fontName = @"Helvetica";
    // axis label font size
    xAxis.style.labelStyle.fontSize = 14;
    // drawing ticks is enabled by default. That lines are added just to show that such propertyes exist and what they do
    xAxis.style.drawMajorTicks = YES;
    xAxis.style.drawMinorTicks = YES;
    // drawing labels is enabled by default to. If set to false, there will be no labels on axis. Labels are placed at majot tick position
    xAxis.style.drawLabels = YES;
    // major ticks are marks on axis that are located at label
    // length of major tick in points
    xAxis.style.majorTickSize = 5;
    // color and thicknes of major tick
    xAxis.style.majorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:1];
    // minor ticks are marks on axis that fills space between major ticks
    // length of minor tick in points
    xAxis.style.minorTickSize = 2;
    // color and thicknes of minor tick
    xAxis.style.minorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:0.5];
    
    id <SCIAxis2DProtocol> yRightAxis = [[SCINumericAxis alloc] init];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    // setting axis band color. Band is filled area between major grid lines
    yRightAxis.style.gridBandBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x70000000];
    // changing major grid line color and thicknes. major grid line is line at the label position
    yRightAxis.style.majorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:1];
    // changing minor grid line color and thicknes. minor grid lines are located between major grid lines
    yRightAxis.style.minorGridLineBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:0.5];
    // set custom label provider for axis. Label provider defines text for labels
    yRightAxis.labelProvider = [[ThousandsLabelProvider alloc] init];
    // axis label color
    yRightAxis.style.labelStyle.color = UIColor.darkGrayColor;
    // axis label font size
    yRightAxis.style.labelStyle.fontSize = 12;
    // major ticks are marks on axis that are located at label
    // length of major tick in points
    yRightAxis.style.majorTickSize = 3;
    // color and thicknes of major tick
    yRightAxis.style.majorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:1];
    // minor ticks are marks on axis that fills space between major ticks
    // length of minor tick in points
    yRightAxis.style.minorTickSize = 2;
    // color and thicknes of minor tick
    yRightAxis.style.minorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:0.5];
    
    id <SCIAxis2DProtocol> yLeftAxis = [[SCINumericAxis alloc] init];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(3)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    // we are disabling bands and grid on secondary Y axis
    yLeftAxis.style.drawMajorBands = NO;
    yLeftAxis.style.drawMajorGridLines = NO;
    yLeftAxis.style.drawMinorGridLines = NO;
    // set custom label provider for axis
    yLeftAxis.labelProvider = [[BillionsLabelProvider alloc] init];
    // axis label color
    yLeftAxis.style.labelStyle.color = UIColor.darkGrayColor;
    // axis label font size
    yLeftAxis.style.labelStyle.fontSize = 12;
    // major ticks are marks on axis that are located at label
    // length of major tick in points
    yLeftAxis.style.majorTickSize = 3;
    // color and thicknes of major tick
    yLeftAxis.style.majorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:1];
    // minor ticks are marks on axis that fills space between major ticks
    // length of minor tick in points
    yLeftAxis.style.minorTickSize = 2;
    // color and thicknes of minor tick
    yLeftAxis.style.minorTickBrush = [[SCISolidPenStyle alloc] initWithColor:UIColor.blackColor withThickness:0.5];
    
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
