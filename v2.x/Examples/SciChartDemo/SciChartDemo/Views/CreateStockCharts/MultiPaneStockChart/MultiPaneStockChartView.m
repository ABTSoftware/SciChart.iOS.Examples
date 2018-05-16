//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MultiPaneStockChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "MultiPaneStockChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "MovingAverage.h"
#import <math.h>

NSString * const VOLUME = @"Volume";
NSString * const PRICES = @"Prices";
NSString * const RSI = @"RSI";
NSString * const MACD = @"MACD";

@interface BasePaneModel : NSObject

@property(nonatomic) SCIRenderableSeriesCollection * renderableSeries;
@property(nonatomic) SCIAnnotationCollection * annotations;
@property(nonatomic) SCINumericAxis * yAxis;
@property(nonatomic) NSString * title;

- (instancetype)initWithTitle:(NSString *)title yAxisTextFormatting:(NSString *)yAxisTextFormatting isFirstPane:(BOOL)isFirstPane;
- (void)addRenderableSeries:(SCIRenderableSeriesBase *)renderableSeries;

@end

@interface PricePaneModel : BasePaneModel
- (instancetype)initWithSeries:(PriceSeries *)priceSeries;
@end

@interface VolumePaneModel : BasePaneModel
- (instancetype)initWithSeries:(PriceSeries *)priceSeries;
@end

@interface RsiPaneModel : BasePaneModel
- (instancetype)initWithSeries:(PriceSeries *)priceSeries;
@end

@interface MacdPaneModel : BasePaneModel
- (instancetype)initWithSeries:(PriceSeries *)priceSeries;
@end

@interface MultiPaneStockChartView ()

@property SCIAxisRangeSynchronization * rangeSync;
@property SCIAxisAreaSizeSynchronization * axisAreaSizeSync;

@end

@implementation MultiPaneStockChartView

- (void)initExample {
    _rangeSync = [SCIAxisRangeSynchronization new];
    _axisAreaSizeSync = [SCIAxisAreaSizeSynchronization new];
    _axisAreaSizeSync.syncMode = SCIAxisSizeSync_Right;
    
    PriceSeries * priceSeries = [DataManager getPriceDataEurUsd];
    
    PricePaneModel * pricePaneModel = [[PricePaneModel alloc] initWithSeries:priceSeries];
    MacdPaneModel * macdPaneModel = [[MacdPaneModel alloc] initWithSeries:priceSeries];
    RsiPaneModel * rsiPaneModel = [[RsiPaneModel alloc] initWithSeries:priceSeries];
    VolumePaneModel * volumePaneModel = [[VolumePaneModel alloc] initWithSeries:priceSeries];
    
    [self initSurface:self.priceSurface paneModel:pricePaneModel isMainPane:YES];
    [self initSurface:self.macdSurface paneModel:macdPaneModel isMainPane:NO];
    [self initSurface:self.rsiSurface paneModel:rsiPaneModel isMainPane:NO];
    [self initSurface:self.volumeSurface paneModel:volumePaneModel isMainPane:NO];
}

- (void)initSurface:(SCIChartSurface *)surface paneModel:(BasePaneModel *)model isMainPane:(BOOL)isMainPane {
    // used to syncronize width of yAxes areas
    [_axisAreaSizeSync attachSurface:surface];
    
    SCICategoryDateTimeAxis * xAxis = [SCICategoryDateTimeAxis new];
    xAxis.isVisible = isMainPane ? YES : NO;
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.05)];
    
    // Used to synchronize axis ranges
    [_rangeSync attachAxis:xAxis];
    
    SCIXAxisDragModifier * xAxisDragModifier = [SCIXAxisDragModifier new];
    xAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    xAxisDragModifier.clipModeX = SCIClipMode_StretchAtExtents;
    
    SCIPinchZoomModifier * pinchZoomModifier = [SCIPinchZoomModifier new];
    pinchZoomModifier.direction = SCIDirection2D_XDirection;
    
    SCILegendModifier * legendModifier = [SCILegendModifier new];
    legendModifier.showCheckBoxes = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:model.yAxis];
        surface.renderableSeries = model.renderableSeries;
        surface.annotations = model.annotations;
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xAxisDragModifier, pinchZoomModifier, [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], legendModifier]];
        
        if (!isMainPane) {
            surface.topAxisAreaForcedSize = 0.5;
            surface.bottomAxisAreaForcedSize = 0.5;
            [SCIThemeManager applyDefaultThemeToThemeable:surface];
        }
    }];
}

@end

@implementation BasePaneModel

@synthesize renderableSeries = _renderableSeries;
@synthesize annotations = _annotations;
@synthesize yAxis = _yAxis;
@synthesize title = _title;

- (instancetype)initWithTitle:(NSString *)title yAxisTextFormatting:(NSString *)yAxisTextFormatting isFirstPane:(BOOL)isFirstPane {
    self = [super init];
    
    if (self) {
        _title = title;
        _renderableSeries = [SCIRenderableSeriesCollection new];
        _annotations = [SCIAnnotationCollection new];
        
        _yAxis = [SCINumericAxis new];
        _yAxis.axisId = title;
        if (yAxisTextFormatting != nil) {
            _yAxis.textFormatting = yAxisTextFormatting;
        }
        _yAxis.autoRange = SCIAutoRange_Always;
        _yAxis.minorsPerMajor = isFirstPane ? 4 : 2;
        _yAxis.maxAutoTicks = isFirstPane ? 8 : 4;
        
        double growBy = isFirstPane ? 0.05 : 0.0;
        _yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(growBy) Max:SCIGeneric(growBy)];
    }
    
    return self;
}

- (void)addRenderableSeries:(SCIRenderableSeriesBase *)renderableSeries {
    [_renderableSeries add:renderableSeries];
}

- (void)addAxisMarkerAnnotationWithYAxisId:(NSString *)yAxisId format:(NSString *)format value:(SCIGenericType)value color:(UIColor *)color {
    SCITextFormattingStyle * textFormatting = [SCITextFormattingStyle new];
    textFormatting.color = [UIColor whiteColor];
    textFormatting.fontSize = 12;
    
    SCIAxisMarkerAnnotation * axisMarkerAnnotation = [SCIAxisMarkerAnnotation new];
    axisMarkerAnnotation.yAxisId = yAxisId;
    axisMarkerAnnotation.position = value;
    axisMarkerAnnotation.coordinateMode = SCIAnnotationCoordinate_Absolute;
    if (color != nil) {
        axisMarkerAnnotation.style.backgroundColor = color;
    }
    axisMarkerAnnotation.style.margin = 5;
    axisMarkerAnnotation.style.textStyle = textFormatting;
    axisMarkerAnnotation.formattedValue = [NSString stringWithFormat: format, SCIGenericDouble(value)];
    
    [_annotations add:axisMarkerAnnotation];
}

@end

@implementation PricePaneModel

- (instancetype)initWithSeries:(PriceSeries *)prices {
    self = [super initWithTitle:PRICES yAxisTextFormatting:@"$0.0000" isFirstPane:YES];
    
    if (self) {
        // Add the main OHLC chart
        SCIOhlcDataSeries * stockPrices = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        stockPrices.seriesName = @"EUR/USD";
        [stockPrices appendRangeX:SCIGeneric(prices.dateData) Open:SCIGeneric(prices.openData) High:SCIGeneric(prices.highData) Low:SCIGeneric(prices.lowData) Close:SCIGeneric(prices.closeData) Count:prices.size];
        
        SCIFastCandlestickRenderableSeries * candlestickSeries = [SCIFastCandlestickRenderableSeries new];
        candlestickSeries.dataSeries = stockPrices;
        candlestickSeries.yAxisId = PRICES;
        [self addRenderableSeries:candlestickSeries];
        [SCIThemeManager applyDefaultThemeToThemeable:candlestickSeries];
        
        double movingAverageArray[prices.size];
        SCIXyDataSeries * maLow = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        maLow.seriesName = @"Low Line";
        [maLow appendRangeX:SCIGeneric(prices.dateData) Y:SCIGeneric([MovingAverage movingAverage:prices.closeData output:movingAverageArray count:prices.size period:50]) Count:prices.size];
        
        SCIFastLineRenderableSeries * lineSeriesLow = [SCIFastLineRenderableSeries new];
        lineSeriesLow.dataSeries = maLow;
        lineSeriesLow.yAxisId = PRICES;
        lineSeriesLow.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF3333 withThickness:1];
        [self addRenderableSeries:lineSeriesLow];
        
        SCIXyDataSeries * maHigh = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        maHigh.seriesName = @"High Line";
        [maHigh appendRangeX:SCIGeneric(prices.dateData) Y:SCIGeneric([MovingAverage movingAverage:prices.closeData output:movingAverageArray count:prices.size period:200]) Count:prices.size];
        
        SCIFastLineRenderableSeries * lineSeriesHigh = [SCIFastLineRenderableSeries new];
        lineSeriesHigh.dataSeries = maHigh;
        lineSeriesHigh.yAxisId = PRICES;
        lineSeriesHigh.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF33DD33 withThickness:1];
        [self addRenderableSeries:lineSeriesHigh];
        
        [self addAxisMarkerAnnotationWithYAxisId:PRICES format:@"$%.4f" value:[stockPrices.yColumn valueAt:stockPrices.count -1] color:lineSeriesLow.strokeStyle.color];
        [self addAxisMarkerAnnotationWithYAxisId:PRICES format:@"$%.4f" value:[maLow.yColumn valueAt:maLow.count -1] color:lineSeriesLow.strokeStyle.color];
        [self addAxisMarkerAnnotationWithYAxisId:PRICES format:@"$%.4f" value:[maHigh.yColumn valueAt:maHigh.count -1] color:lineSeriesHigh.strokeStyle.color];
    }
    
    return self;
}

@end

@implementation VolumePaneModel

- (instancetype)initWithSeries:(PriceSeries *)prices {
    self = [super initWithTitle:VOLUME yAxisTextFormatting:@"###E+0" isFirstPane:NO];
    
    if (self) {
        SCIXyDataSeries * volumePrices = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        volumePrices.seriesName = @"Volume";
        [volumePrices appendRangeX:SCIGeneric(prices.dateData) Y:SCIGeneric(prices.volumeData) Count:prices.size];
        
        SCIFastColumnRenderableSeries * columnSeries = [SCIFastColumnRenderableSeries new];
        columnSeries.dataSeries = volumePrices;
        columnSeries.yAxisId = VOLUME;
        [self addRenderableSeries:columnSeries];
        
        [self addAxisMarkerAnnotationWithYAxisId:VOLUME format:@"$%.g" value:[volumePrices.yColumn valueAt:volumePrices.count -1] color:nil];
    }
    
    return self;
}

@end

@implementation RsiPaneModel

- (instancetype)initWithSeries:(PriceSeries *)prices {
    self = [super initWithTitle:RSI yAxisTextFormatting:@"0.0" isFirstPane:NO];
    
    if (self) {
        double rsiArray[prices.size];
        SCIXyDataSeries * rsiDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        rsiDataSeries.seriesName = @"RSI";
        [rsiDataSeries appendRangeX:SCIGeneric(prices.dateData) Y:SCIGeneric([MovingAverage rsi:prices output:rsiArray count:prices.size period:14]) Count:prices.size];
        
        SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
        lineSeries.dataSeries = rsiDataSeries;
        lineSeries.yAxisId = RSI;
        lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFC6E6FF withThickness:1];
        [self addRenderableSeries:lineSeries];
        
        [self addAxisMarkerAnnotationWithYAxisId:RSI format:@"%.2f" value:[rsiDataSeries.yColumn valueAt:rsiDataSeries.count -1] color:nil];
    }
    
    return self;
}

@end

@implementation MacdPaneModel

- (instancetype)initWithSeries:(PriceSeries *)prices {
    self = [super initWithTitle:MACD yAxisTextFormatting:@"0.00" isFirstPane:NO];
    
    if (self) {
        MacdPoints * macdPoints = [MovingAverage macd:prices.closeData count:prices.size slow:12 fast:25 signal:9];
        
        SCIXyDataSeries * histogramDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        histogramDataSeries.seriesName = @"Histogram";
        [histogramDataSeries appendRangeX:SCIGeneric(prices.dateData) Y:macdPoints.divergenceValues Count:prices.size];
        
        SCIFastColumnRenderableSeries * columnSeries = [SCIFastColumnRenderableSeries new];
        columnSeries.dataSeries = histogramDataSeries;
        columnSeries.yAxisId = MACD;
        [self addRenderableSeries:columnSeries];
        
        SCIXyyDataSeries * macdDataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
        macdDataSeries.seriesName = @"MACD";
        [macdDataSeries appendRangeX:SCIGeneric(prices.dateData) Y1:macdPoints.macdValues Y2:macdPoints.signalValues Count:prices.size];
        
        SCIFastBandRenderableSeries * bandSeries = [SCIFastBandRenderableSeries new];
        bandSeries.dataSeries = macdDataSeries;
        bandSeries.yAxisId = MACD;
        [self addRenderableSeries:bandSeries];
        
        [self addAxisMarkerAnnotationWithYAxisId:MACD format:@"$%.2f" value:[histogramDataSeries.yColumn valueAt:histogramDataSeries.count -1] color:nil];
        [self addAxisMarkerAnnotationWithYAxisId:MACD format:@"$%.2f" value:[macdDataSeries.yColumn valueAt:macdDataSeries.count -1] color:nil];
    }
    
    return self;
}

@end
