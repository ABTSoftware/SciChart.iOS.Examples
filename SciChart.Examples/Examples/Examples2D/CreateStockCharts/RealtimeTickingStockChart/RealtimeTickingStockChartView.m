//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeTickingStockChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealtimeTickingStockChartView.h"
#import "SCDDataManager.h"
#import "SCDPriceSeries.h"
#import "SCDMovingAverage.h"
#import "SCDMarketDataService.h"

static int const DefaultPointCount = 150;
static unsigned int const SmaSeriesColor = 0xFFe97064;
static unsigned int const StrokeUpColor = 0xFF68bcae;
static unsigned int const StrokeDownColor = 0xFFae418d;

@implementation RealtimeTickingStockChartView {
    SCIOhlcDataSeries *_ohlcDataSeries;
    SCIXyDataSeries *_xyDataSeries;
    
    SCIAxisMarkerAnnotation *_smaAxisMarker;
    SCIAxisMarkerAnnotation *_ohlcAxisMarker;
    
    SCDMarketDataService *_marketDataService;
    SCDMovingAverage *_sma50;
    SCDPriceBar *_lastPrice;
    
    id<ISCIAxis> mainXAxis, mainYAxis;
    SCIRangeSelectorAnnotation *rangeSelectorAnnotation;
    
    BOOL isDragging;
}

- (void)initExample {
    _marketDataService = [[SCDMarketDataService alloc] initWithStartDate:[NSDate dateWithYear:2000 month:8 day:01 hour:12 minute:0 second:0] TimeFrameMinutes:5 TickTimerIntervals:0.02];
    _sma50 = [[SCDMovingAverage alloc] initWithLength:50];
    [self initDataWithService:_marketDataService];
    
    [self createMainPriceChart];
    [self createOverviewChart];
    
    id<ISCIAxisCore> axis = [self.mainSurface.xAxes itemAt:0];
    
    __weak typeof(self) wSelf = self;
    axis.visibleRangeChangeListener = ^(id<ISCIAxisCore> axis, id<ISCIRange> oldRange, id<ISCIRange> newRange, BOOL isAnimating) {
        
        RealtimeTickingStockChartView *strongPointer = wSelf;
        
        if (!strongPointer->isDragging) {
            strongPointer->rangeSelectorAnnotation.x1 = @(axis.visibleRange.minAsDouble);
            strongPointer->rangeSelectorAnnotation.x2 = @(axis.visibleRange.maxAsDouble);
        }
    };
}

- (void)initDataWithService:(SCDMarketDataService *)marketDataService {
    _ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    _ohlcDataSeries.seriesName = @"Price Series";
    _xyDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    _xyDataSeries.seriesName = @"50-Period SMA";
    
    SCDPriceSeries *prices = [marketDataService getHistoricalData:DefaultPointCount];
    _lastPrice = [prices lastObject];

    [_ohlcDataSeries appendValuesX:prices.dateData open:prices.openData high:prices.highData low:prices.lowData close:prices.closeData];
    [_xyDataSeries appendValuesX:prices.dateData y:[self getSmaCurrentValues:prices]];
    
    [self subscribePriceUpdate];
}

- (SCIDoubleValues *)getSmaCurrentValues:(SCDPriceSeries *)prices {
    SCIDoubleValues *result = [SCIDoubleValues new];
    SCIDoubleValues *closeData = prices.closeData;
    
    for (NSInteger i = 0, count = closeData.count; i < count; i++) {
        double close = [prices itemAt:i].close.doubleValue;
        [result add:[_sma50 push:close].current];
    }
    
    return result;
}

- (void)createMainPriceChart {
    mainXAxis = [SCICategoryDateAxis new];
    mainXAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    mainXAxis.drawMajorGridLines = NO;
    
    mainYAxis = [SCINumericAxis new];
    mainYAxis.autoRange = SCIAutoRange_Always;
    
    SCIFastOhlcRenderableSeries *ohlcSeries = [SCIFastOhlcRenderableSeries new];
    ohlcSeries.dataSeries = _ohlcDataSeries;

    SCIFastLineRenderableSeries *ma50Series = [SCIFastLineRenderableSeries new];
    ma50Series.dataSeries = _xyDataSeries;
    ma50Series.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe97064 thickness:1];
    
    _smaAxisMarker = [SCIAxisMarkerAnnotation new];
    _smaAxisMarker.y1 = @(0);
    _smaAxisMarker.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:SmaSeriesColor thickness:1];
    _smaAxisMarker.backgroundBrush = [[SCISolidBrushStyle alloc] initWithColorCode:SmaSeriesColor];
    
    _ohlcAxisMarker = [SCIAxisMarkerAnnotation new];
    _ohlcAxisMarker.y1 = @(0);
    _ohlcAxisMarker.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:StrokeUpColor thickness:1];
    _ohlcAxisMarker.backgroundBrush = [[SCISolidBrushStyle alloc] initWithColorCode:StrokeUpColor];
    
    SCIZoomPanModifier *zoomPanModifier = [SCIZoomPanModifier new];
    zoomPanModifier.direction = SCIDirection2D_XDirection;
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.orientation = SCIOrientationHorizontal;
    legendModifier.position = SCIAlignment_Bottom | SCIAlignment_CenterHorizontal;
    legendModifier.margins = (SCIEdgeInsets){.left = 10, .top = 10, .right = 10, .bottom = 10};
    
    [SCIUpdateSuspender usingWithSuspendable:self.mainSurface withBlock:^{
        [self.mainSurface.xAxes add:self->mainXAxis];
        [self.mainSurface.yAxes add:self->mainYAxis];
        [self.mainSurface.renderableSeries addAll:ma50Series, ohlcSeries, nil];
        [self.mainSurface.annotations addAll:self->_smaAxisMarker, self->_ohlcAxisMarker, nil];
        [self.mainSurface.chartModifiers addAll:[SCIXAxisDragModifier new], zoomPanModifier, [SCIZoomExtentsModifier new], legendModifier, [SCIPinchZoomModifier new], nil];
    }];
}

- (void)createOverviewChart {
    id<ISCIAxis> xAxis = [SCICategoryDateAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIFastMountainRenderableSeries *mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = _ohlcDataSeries;
    mountainSeries.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0, 1) startColorCode:0x883a668f endColorCode:0xff20384f];
    
    [self configureRangeSelectorAnnotation];
    
    [SCIUpdateSuspender usingWithSuspendable:self.overviewSurface withBlock:^{
        [self.overviewSurface.xAxes add:xAxis];
        [self.overviewSurface.yAxes add:yAxis];
        [self.overviewSurface.renderableSeries add:mountainSeries];
    }];
}

- (void)onNewPrice:(SCDPriceBar *)price {
    double smaLastValue;
    if (_lastPrice.date == price.date) {
        [_ohlcDataSeries updateOpen:price.open high:price.high low:price.low close:price.close at:_ohlcDataSeries.count - 1];
        
        smaLastValue = [_sma50 update:price.close.doubleValue].current;
        [_xyDataSeries updateY:@(smaLastValue) at:_xyDataSeries.count - 1];
    } else {
        [_ohlcDataSeries appendX:price.date open:price.open high:price.high low:price.low close:price.close];
        
        smaLastValue = [_sma50 push:price.close.doubleValue].current;
        [_xyDataSeries appendX:price.date y:@(smaLastValue)];
 
        id<ISCIRange> visibleRange = self.mainSurface.xAxes[0].visibleRange;
        if (visibleRange.maxAsDouble > _ohlcDataSeries.count) {
            [visibleRange setDoubleMinTo:visibleRange.minAsDouble + 1 maxTo:visibleRange.maxAsDouble + 1];
        }
    }
    
    unsigned int color = [price.close compare:price.open] == NSOrderedDescending ? StrokeUpColor : StrokeDownColor;
    _ohlcAxisMarker.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:1];
    _ohlcAxisMarker.backgroundBrush = [[SCISolidBrushStyle alloc] initWithColorCode:color];
    _ohlcAxisMarker.y1 = price.close;
    _smaAxisMarker.y1 = @(smaLastValue);
    
    _lastPrice = price;
}

- (void)subscribePriceUpdate {
    __weak typeof(self) wSelf = self;
    [_marketDataService subscribePriceUpdate:^(SCDPriceBar * _Nonnull priceBar) { [wSelf onNewPrice:priceBar]; }];
}

- (void)clearSubscribtions {
    [_marketDataService clearSubscriptions];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_marketDataService clearSubscriptions];
}

-(void)configureRangeSelectorAnnotation {
    
    rangeSelectorAnnotation = [SCIRangeSelectorAnnotation new];
    
    rangeSelectorAnnotation.y1 = @(0);
    rangeSelectorAnnotation.y2 = @(1);
    rangeSelectorAnnotation.x1 = @(mainXAxis.visibleRange.minAsDouble);
    rangeSelectorAnnotation.x2 = @(mainXAxis.visibleRange.maxAsDouble);
    rangeSelectorAnnotation.xAxisId = mainXAxis.axisId;
    rangeSelectorAnnotation.yAxisId = mainYAxis.axisId;
    
    rangeSelectorAnnotation.coordinateMode = SCIAnnotationCoordinateMode_RelativeY;
    rangeSelectorAnnotation.dragDirections = SCIDirection2D_XDirection;
    
    rangeSelectorAnnotation.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FFFFFF];
    
    SCIOverviewAnnotationDragListener *dragListener = [SCIOverviewAnnotationDragListener new];
    dragListener.dragDelegate = self;
    rangeSelectorAnnotation.annotationDragListener = dragListener;
    
    [self.overviewSurface.annotations addAll:rangeSelectorAnnotation, nil];
}

-(void)changeVisibleRange:(id<ISCIAnnotation>)annotation isFromOnDrag:(BOOL)isFromOnDrag  {
#if TARGET_OS_IOS
    [SCIView animateWithDuration:2.0
                          delay:0
                        options:UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
        self->mainXAxis.visibleRange.min = annotation.x1;
        self->mainXAxis.visibleRange.max = annotation.x2;
    }
                     completion:^(BOOL finished) {
        if (!isFromOnDrag) {
            self->isDragging = NO;
        }
        self->rangeSelectorAnnotation.isSelected = YES;
        
    }];
#else
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:2.0];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
    if (!isFromOnDrag) {
        self->isDragging = NO;
    }
        self->rangeSelectorAnnotation.isSelected = YES;
    }];

    self->mainXAxis.visibleRange.min = annotation.x1;
    self->mainXAxis.visibleRange.max = annotation.x2;

    [NSAnimationContext endGrouping];
#endif
}

#pragma mark - Drag Delegates
- (void)onDragStarted:(id<ISCIAnnotation>)annotation {
    isDragging = YES;
}

- (void)onDragAnnotation:(id<ISCIAnnotation>)annotation byXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta {
    [self changeVisibleRange:annotation isFromOnDrag:YES];
}

- (void)onDragEnded:(id<ISCIAnnotation>)annotation {
    
    [self changeVisibleRange:annotation isFromOnDrag:NO];
}
@end
