//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"
#import "SCDMovingAverage.h"

NSString * const VOLUME = @"Volume";
NSString * const PRICES = @"Prices";
NSString * const RSI = @"RSI";
NSString * const MACD = @"MACD";

// MARK: - Chart Panes Interfaces

@interface BasePaneModel : NSObject

@property (nonatomic) SCIRenderableSeriesCollection *renderableSeries;
@property (nonatomic) SCIAnnotationCollection *annotations;
@property (nonatomic) SCINumericAxis *yAxis;
@property (nonatomic) NSString *title;

- (instancetype)initWithTitle:(NSString *)title yAxisTextFormatting:(NSString *)yAxisTextFormatting isFirstPane:(BOOL)isFirstPane;
- (void)addRenderableSeries:(SCIRenderableSeriesBase *)renderableSeries;

@end

@interface PricePaneModel : BasePaneModel
- (instancetype)initWithSeries:(SCDPriceSeries *)priceSeries;
@end

@interface VolumePaneModel : BasePaneModel
- (instancetype)initWithSeries:(SCDPriceSeries *)priceSeries;
@end

@interface RsiPaneModel : BasePaneModel
- (instancetype)initWithSeries:(SCDPriceSeries *)priceSeries;
@end

@interface MacdPaneModel : BasePaneModel
- (instancetype)initWithSeries:(SCDPriceSeries *)priceSeries;
@end

// MARK: - Charts Initialization

@implementation MultiPaneStockChartView {
    SCIChartVerticalGroup *_verticalGroup;
    SCIDoubleRange *_sharedXRange;
}

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    _verticalGroup = [SCIChartVerticalGroup new];
    _sharedXRange = [SCIDoubleRange new];
    
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataEurUsd];
    
    PricePaneModel *pricePaneModel = [[PricePaneModel alloc] initWithSeries:priceSeries];
    MacdPaneModel *macdPaneModel = [[MacdPaneModel alloc] initWithSeries:priceSeries];
    RsiPaneModel *rsiPaneModel = [[RsiPaneModel alloc] initWithSeries:priceSeries];
    VolumePaneModel *volumePaneModel = [[VolumePaneModel alloc] initWithSeries:priceSeries];
    
    [self initSurface:self.priceSurface paneModel:pricePaneModel isMainPane:YES];
    [self initSurface:self.macdSurface paneModel:macdPaneModel isMainPane:NO];
    [self initSurface:self.rsiSurface paneModel:rsiPaneModel isMainPane:NO];
    [self initSurface:self.volumeSurface paneModel:volumePaneModel isMainPane:NO];
}

- (void)initSurface:(SCIChartSurface *)surface paneModel:(BasePaneModel *)model isMainPane:(BOOL)isMainPane {
    SCICategoryDateAxis *xAxis = [SCICategoryDateAxis new];
    xAxis.isVisible = isMainPane;
    xAxis.visibleRange = _sharedXRange;
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.05];
    
    SCIXAxisDragModifier *xAxisDragModifier = [SCIXAxisDragModifier new];
    xAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    xAxisDragModifier.clipModeX = SCIClipMode_StretchAtExtents;

    SCIPinchZoomModifier *pinchZoomModifier = [SCIPinchZoomModifier new];
    pinchZoomModifier.direction = SCIDirection2D_XDirection;

    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.showCheckBoxes = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:model.yAxis];
        surface.renderableSeries = model.renderableSeries;
        surface.annotations = model.annotations;
        [surface.chartModifiers addAll:xAxisDragModifier, pinchZoomModifier, [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], legendModifier, nil];
        
        [self->_verticalGroup addSurfaceToGroup:surface];
    }];
}

@end

// MARK: - Base Chart Pane

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
        _yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:growBy max:growBy];
    }
    return self;
}

- (void)addRenderableSeries:(SCIRenderableSeriesBase *)renderableSeries {
    [_renderableSeries add:renderableSeries];
}

- (void)addAxisMarkerAnnotationWithYAxisId:(NSString *)yAxisId format:(NSString *)format value:(id<ISCIComparable>)value color:(SCIColor *)color {
    SCIAxisMarkerAnnotation *axisMarkerAnnotation = [SCIAxisMarkerAnnotation new];
    axisMarkerAnnotation.yAxisId = yAxisId;
    axisMarkerAnnotation.y1 = value;
    axisMarkerAnnotation.coordinateMode = SCIAnnotationCoordinateMode_Absolute;
    if (color != nil) {
        axisMarkerAnnotation.backgroundBrush = [[SCISolidBrushStyle alloc] initWithColor:color];
    }
    axisMarkerAnnotation.formattedValue = [NSString stringWithFormat: format, value.toDouble];
    
    [_annotations add:axisMarkerAnnotation];
}

@end

// MARK: - Price Pane

@implementation PricePaneModel

- (instancetype)initWithSeries:(SCDPriceSeries *)prices {
    self = [super initWithTitle:PRICES yAxisTextFormatting:@"$0.0000" isFirstPane:YES];
    if (self) {
        // Add the main OHLC chart
        SCIOhlcDataSeries *stockPrices = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
        stockPrices.seriesName = @"EUR/USD";
        [stockPrices appendValuesX:prices.dateData open:prices.openData high:prices.highData low:prices.lowData close:prices.closeData];
        
        SCIFastCandlestickRenderableSeries *candlestickSeries = [SCIFastCandlestickRenderableSeries new];
        candlestickSeries.dataSeries = stockPrices;
        candlestickSeries.yAxisId = PRICES;
        [self addRenderableSeries:candlestickSeries];
        
        SCIXyDataSeries *maLow = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
        maLow.seriesName = @"Low Line";
        [maLow appendValuesX:prices.dateData y:[SCDMovingAverage movingAverage:prices.closeData period:50]];
        
        SCIFastLineRenderableSeries *lineSeriesLow = [SCIFastLineRenderableSeries new];
        lineSeriesLow.dataSeries = maLow;
        lineSeriesLow.yAxisId = PRICES;
        lineSeriesLow.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe97064 thickness:1];
        [self addRenderableSeries:lineSeriesLow];
        
        SCIXyDataSeries *maHigh = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
        maHigh.seriesName = @"High Line";
        [maHigh appendValuesX:prices.dateData y:[SCDMovingAverage movingAverage:prices.closeData period:200]];
        
        SCIFastLineRenderableSeries *lineSeriesHigh = [SCIFastLineRenderableSeries new];
        lineSeriesHigh.dataSeries = maHigh;
        lineSeriesHigh.yAxisId = PRICES;
        lineSeriesHigh.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1];
        [self addRenderableSeries:lineSeriesHigh];
        
        [self addAxisMarkerAnnotationWithYAxisId:PRICES format:@"$%.4f" value:[stockPrices.yValues valueAt:stockPrices.count - 1] color:lineSeriesLow.strokeStyle.color];
        [self addAxisMarkerAnnotationWithYAxisId:PRICES format:@"$%.4f" value:[maLow.yValues valueAt:maLow.count - 1] color:lineSeriesLow.strokeStyle.color];
        [self addAxisMarkerAnnotationWithYAxisId:PRICES format:@"$%.4f" value:[maHigh.yValues valueAt:maHigh.count - 1] color:lineSeriesHigh.strokeStyle.color];
    }
    return self;
}

@end

// MARK: - Volume Pane

@implementation VolumePaneModel

- (instancetype)initWithSeries:(SCDPriceSeries *)prices {
    self = [super initWithTitle:VOLUME yAxisTextFormatting:@"###E+0" isFirstPane:NO];
    if (self) {
        SCIXyDataSeries *volumePrices = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Long];
        volumePrices.seriesName = @"Volume";
        [volumePrices appendValuesX:prices.dateData y:prices.volumeData];
        
        SCIFastColumnRenderableSeries *columnSeries = [SCIFastColumnRenderableSeries new];
        columnSeries.dataSeries = volumePrices;
        columnSeries.yAxisId = VOLUME;
        [self addRenderableSeries:columnSeries];
        
        [self addAxisMarkerAnnotationWithYAxisId:VOLUME format:@"$%.g" value:[volumePrices.yValues valueAt:volumePrices.count - 1] color:nil];
    }
    return self;
}

@end

// MARK: - RSI Pane

@implementation RsiPaneModel

- (instancetype)initWithSeries:(SCDPriceSeries *)prices {
    self = [super initWithTitle:RSI yAxisTextFormatting:@"0.0" isFirstPane:NO];
    if (self) {
        SCIXyDataSeries *rsiDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
        rsiDataSeries.seriesName = @"RSI";
        [rsiDataSeries appendValuesX:prices.dateData y:[SCDMovingAverage rsi:prices period:14]];
        
        SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
        lineSeries.dataSeries = rsiDataSeries;
        lineSeries.yAxisId = RSI;
        lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFC6E6FF thickness:1];
        [self addRenderableSeries:lineSeries];
        
        [self addAxisMarkerAnnotationWithYAxisId:RSI format:@"%.2f" value:[rsiDataSeries.yValues valueAt:rsiDataSeries.count - 1] color:nil];
    }
    return self;
}

@end

// MARK: - MACD Pane

@implementation MacdPaneModel

- (instancetype)initWithSeries:(SCDPriceSeries *)prices {
    self = [super initWithTitle:MACD yAxisTextFormatting:@"0.00" isFirstPane:NO];
    if (self) {
        
        SCDMacdPoints *macdPoints = [SCDMovingAverage macd:prices.closeData slow:12 fast:25 signal:9];
        
        SCIXyDataSeries *histogramDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
        histogramDataSeries.seriesName = @"Histogram";
        [histogramDataSeries appendValuesX:prices.dateData y:macdPoints.divergenceValues];
        
        SCIFastColumnRenderableSeries *columnSeries = [SCIFastColumnRenderableSeries new];
        columnSeries.dataSeries = histogramDataSeries;
        columnSeries.yAxisId = MACD;
        [self addRenderableSeries:columnSeries];
        
        SCIXyyDataSeries *macdDataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
        macdDataSeries.seriesName = @"MACD";
        [macdDataSeries appendValuesX:prices.dateData y:macdPoints.macdValues y1:macdPoints.signalValues];
        
        SCIFastBandRenderableSeries *bandSeries = [SCIFastBandRenderableSeries new];
        bandSeries.dataSeries = macdDataSeries;
        bandSeries.yAxisId = MACD;
        [self addRenderableSeries:bandSeries];
        
        [self addAxisMarkerAnnotationWithYAxisId:MACD format:@"$%.2f" value:[histogramDataSeries.yValues valueAt:histogramDataSeries.count - 1] color:nil];
        [self addAxisMarkerAnnotationWithYAxisId:MACD format:@"$%.2f" value:[macdDataSeries.yValues valueAt:macdDataSeries.count - 1] color:nil];
    }
    return self;
}

@end
