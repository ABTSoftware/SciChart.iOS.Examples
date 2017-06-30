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

static NSString * _Nonnull const SCIChart_BerryBlueStyleKey = @"SciChart_BerryBlue";

@interface ThemeCustomChartView ()

@property (nonatomic) NSArray <SCDMultiPaneItem*> *dataSource;

@end

@implementation ThemeCustomChartView

@synthesize surface;

- (void)initializeSurfaceRenderableSeries{
    
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [priceDataSeries setSeriesName:@"Line Series"];
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries setPointMarker:nil];
    [priceRenderableSeries setXAxisId: @"xAxis"];
    [priceRenderableSeries setYAxisId: @"yAxis"];
    priceRenderableSeries.zeroLineY = 2000;
    [priceRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:priceRenderableSeries];
    
    
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float
                                                                            YType:SCIDataType_Float];
    [ohlcDataSeries setSeriesName:@"Candle Series"];
    
    SCIFastCandlestickRenderableSeries * candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    candlestickRenderableSeries.xAxisId = @"xAxis";
    candlestickRenderableSeries.yAxisId = @"yAxis";
    candlestickRenderableSeries.zeroLineY = 5000;
    [candlestickRenderableSeries setDataSeries: ohlcDataSeries];
    [surface.renderableSeries add:candlestickRenderableSeries];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double
                                                                            YType:SCIDataType_Double];
    [mountainDataSeries setSeriesName:@"Mountain Series"];
    
    SCIFastMountainRenderableSeries * mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.xAxisId = @"xAxis";
    mountainRenderableSeries.yAxisId = @"yAxis";
    mountainRenderableSeries.zeroLineY = 5000;
    [mountainRenderableSeries setDataSeries: mountainDataSeries];
    
    [surface.renderableSeries add:mountainRenderableSeries];
    
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double
                                                                          YType:SCIDataType_Double];
    [columnDataSeries setSeriesName:@"Column Series"];
    
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"xAxis";
    columnRenderableSeries.yAxisId = @"yAxis";
    columnRenderableSeries.zeroLineY = 5000;
    [columnRenderableSeries setDataSeries:columnDataSeries];
    [surface.renderableSeries add:columnRenderableSeries];
    
    SCDMovingAverage *averageHigh = [[SCDMovingAverage alloc] initWithLength:20];
    int i = 0;
    for (SCDMultiPaneItem *item in self.dataSource) {
        
        
        SCIGenericType date = SCIGeneric(i);
        SCIGenericType open = SCIGeneric(item.open);
        SCIGenericType high = SCIGeneric(item.high);
        SCIGenericType low = SCIGeneric(item.low);
        SCIGenericType close = SCIGeneric(item.close);
        
        [ohlcDataSeries appendX:date
                           Open:open
                           High:high
                            Low:low
                          Close:close];
        
        [priceDataSeries appendX:date Y:SCIGeneric([averageHigh push:item.close].current)];
        [mountainDataSeries appendX:date Y:SCIGeneric(item.close - 1000)];
        [columnDataSeries appendX:date Y:SCIGeneric(item.close - 1500)];
        i++;
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _dataSource = [DataManager loadThemeData];
        
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:surface];
        
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];

        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)p_applyCustomTheme {
    [SCIThemeManager addThemeByThemeKey:SCIChart_BerryBlueStyleKey];
    [SCIThemeManager applyThemeToThemeable:surface withThemeKey:SCIChart_BerryBlueStyleKey];
}

- (void)initializeSurfaceData {
    
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
    
    [self p_applyCustomTheme];
    
}

- (void)addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    textFormatting.fontSize = 16;
    textFormatting.fontName = @"Helvetica";
    textFormatting.colorCode = 0xFFb6b3af;
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    axisStyle.majorTickBrush = majorPen;
    axisStyle.gridBandBrush = gridBandPen;
    axisStyle.majorGridLineBrush = majorPen;
    axisStyle.minorTickBrush = minorPen;
    axisStyle.minorGridLineBrush = minorPen;
    axisStyle.labelStyle = textFormatting;
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    axis.labelProvider = [ThousandsLabelProvider new];
    axis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.3)];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis2";
    axis.style = axisStyle;
    axis.labelProvider = [BillionsLabelProvider new];
    axis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    axis.axisAlignment = SCIAxisAlignment_Left;
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    axis.style = axisStyle;
    axis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(150) Max:SCIGeneric(180)];
    [surface.xAxes add:axis];
    
}

- (void)addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    [xDragModifier setModifierName:@"XAxis DragModifier"];
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    [yDragModifier setModifierName:@"YAxis DragModifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    [rollover setModifierName:@"Rollover Modifier"];
    
    SCILegendModifier *legend = [[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop
                                                                                 andOrientation:SCIOrientationVertical];
    legend.showCheckBoxes = NO;
    legend.styleOfItemCell = [SCILegendCellStyle new];
    legend.styleOfItemCell.seriesNameFont = [UIFont systemFontOfSize:10];
    legend.styleOfItemCell.cornerRadiusMarkerView = .0f;
    legend.styleOfItemCell.borderWidthMarkerView = .0f;
    legend.styleOfItemCell.seriesNameTextColor = [UIColor whiteColor];
    legend.styleOfItemCell.sizeMarkerView = CGSizeMake(30.f, 6.f);
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, legend]];
    surface.chartModifiers = gm;
}

@end
