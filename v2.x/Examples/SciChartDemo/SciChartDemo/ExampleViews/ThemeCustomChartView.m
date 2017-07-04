//
//  ThemeCustomChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 12/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ThemeCustomChartView.h"
#import "DataManager.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"
#import <SciChart/SciChart.h>

static NSString *_Nonnull const SCIChart_BerryBlueStyleKey = @"SciChart_BerryBlue";

@implementation ThemeCustomChartView

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
    SCIAxisStyle *axisStyle = [[SCIAxisStyle alloc] init];
    axisStyle.drawMajorTicks = NO;
    axisStyle.drawMinorTicks = NO;

    id <SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(150) Max:SCIGeneric(180)];

    id <SCIAxis2DProtocol> yRightAxis = [[SCINumericAxis alloc] init];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    yRightAxis.style = axisStyle;
    yRightAxis.labelProvider = [[ThousandsLabelProvider alloc] init];

    id <SCIAxis2DProtocol> yLeftAxis = [[SCINumericAxis alloc] init];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(3)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    yLeftAxis.style = axisStyle;
    yLeftAxis.labelProvider = [[BillionsLabelProvider alloc] init];

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

    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    lineRenderableSeries.dataSeries = lineDataSeries;
    lineRenderableSeries.yAxisId = @"PrimaryAxisId";

    SCIFastColumnRenderableSeries *columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.dataSeries = columnDataSeries;
    columnRenderableSeries.yAxisId = @"SecondaryAxisId";

    SCIFastCandlestickRenderableSeries *candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    candlestickRenderableSeries.dataSeries = candlestickDataSeries;
    candlestickRenderableSeries.yAxisId = @"PrimaryAxisId";

    [surface.xAxes add:xAxis];
    [surface.yAxes add:yRightAxis];
    [surface.yAxes add:yLeftAxis];
    [surface.renderableSeries add:mountainRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    [surface.renderableSeries add:columnRenderableSeries];
    [surface.renderableSeries add:candlestickRenderableSeries];

    SCILegendModifier *legendModifier = [[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop andOrientation:SCIOrientationVertical];
    legendModifier.showCheckBoxes = NO;
    legendModifier.modifierName = @"Legend Modifier";
    SCICursorModifier *cursorModifier = [[SCICursorModifier alloc] init];
    cursorModifier.modifierName = @"Cursor Modifier";
    SCIZoomExtentsModifier *zoomExtentsModifier = [[SCIZoomExtentsModifier alloc] init];
    zoomExtentsModifier.modifierName = @"Zoom Extents Modifier";

    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[legendModifier, cursorModifier, zoomExtentsModifier]];

    [SCIThemeManager applyThemeToThemeable:surface withThemeKey:SCIChart_BerryBlueStyleKey];
}

@end
