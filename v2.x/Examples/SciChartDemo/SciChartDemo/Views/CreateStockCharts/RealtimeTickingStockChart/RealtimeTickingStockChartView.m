//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import "DataManager.h"
#import "PriceSeries.h"
#import "MovingAverage.h"
#import "MarketDataService.h"
#import "NSDate+missingMethods.h"

static int const DefaultPointCount = 150;
static uint const SmaSeriesColor = 0xFFFFA500;
static uint const StrokeUpColor = 0xFF00AA00;
static uint const StrokeDownColor = 0xFFFF0000;

@implementation RealtimeTickingStockChartView {
    uint _smaSeriesColor;
    uint _strokeUpColor;
    uint _strokeDownColor;

    SCIOhlcDataSeries * _ohlcDataSeries;
    SCIXyDataSeries * _xyDataSeries;
    
    SCIAxisMarkerAnnotation * _smaAxisMarker;
    SCIAxisMarkerAnnotation * _ohlcAxisMarker;
    
    MarketDataService * _marketDataService;
    MovingAverage * _sma50;
    PriceBar * _lastPrice;
    
    PriceUpdateCallback onNewPriceBlock;
}

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    onNewPriceBlock = ^(PriceBar * price) { [wSelf onNewPrice:price]; };
    self.continueTickingTouched = ^{ [wSelf subscribePriceUpdate]; };
    self.pauseTickingTouched = ^{ [wSelf clearSubscribtions]; };
    self.seriesTypeTouched = ^{ [wSelf changeSeriesType]; };
}

- (void)initExample {
    _marketDataService = [[MarketDataService alloc] initWithStartDate:[NSDate dateWithYear:2000 month:8 day:01 hour:12 minute:0 second:0] TimeFrameMinutes:5 TickTimerIntervals:0.02];
    _sma50 = [[MovingAverage alloc] initWithLength:50];
    
    [self initDataWithService:_marketDataService];

    [self createMainPriceChart];
    SCIBoxAnnotation * leftAreaAnnotation = [SCIBoxAnnotation new];
    SCIBoxAnnotation * rightAreaAnnotation = [SCIBoxAnnotation new];
    
    [self createOverviewChartWithLeftAnnotation:leftAreaAnnotation RightAnnotation:rightAreaAnnotation];
    
    SCIAxisBase * axis = (SCIAxisBase *)[self.mainSurface.xAxes itemAt:0];
    [axis registerVisibleRangeChangedCallback:^(id<SCIRangeProtocol> newRange, id<SCIRangeProtocol> oldRange, BOOL isAnimated, id sender) {
        leftAreaAnnotation.x1 = [self.overviewSurface.xAxes itemAt:0].visibleRange.min;
        leftAreaAnnotation.x2 = [self.mainSurface.xAxes itemAt:0].visibleRange.min;
        
        rightAreaAnnotation.x1 = [self.mainSurface.xAxes itemAt:0].visibleRange.max;
        rightAreaAnnotation.x2 = [self.overviewSurface.xAxes itemAt:0].visibleRange.max;
    }];

    [_marketDataService subscribePriceUpdate:onNewPriceBlock];
}

- (void)initDataWithService:(MarketDataService *)marketDataService {
    _ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    _ohlcDataSeries.seriesName = @"Price Series";
    _xyDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    _xyDataSeries.seriesName = @"50-Period SMA";
    
    PriceSeries * prices = [marketDataService getHistoricalData:DefaultPointCount];
    _lastPrice = [prices lastObject];

    [_ohlcDataSeries appendRangeX:SCIGeneric(prices.dateData)
                             Open:SCIGeneric(prices.openData)
                             High:SCIGeneric(prices.highData)
                              Low:SCIGeneric(prices.lowData)
                            Close:SCIGeneric(prices.closeData)
                            Count:prices.size];
    double movingAverageArray[prices.size];
    for (int i = 0; i < prices.size; i++) {
        movingAverageArray[i] = [_sma50 push:[prices itemAt:i].close].current;
    }
    [_xyDataSeries appendRangeX:SCIGeneric(prices.dateData) Y:SCIGeneric((double *)movingAverageArray) Count:prices.size];
}

- (void)createMainPriceChart {
    id<SCIAxis2DProtocol> xAxis = [SCICategoryDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.1)];
    xAxis.style.drawMajorGridLines = NO;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIFastOhlcRenderableSeries * ohlcSeries = [SCIFastOhlcRenderableSeries new];
    ohlcSeries.dataSeries = _ohlcDataSeries;

    SCIFastLineRenderableSeries * ma50Series = [SCIFastLineRenderableSeries new];
    ma50Series.dataSeries = _xyDataSeries;
    ma50Series.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF6600 withThickness:1];
    
    _smaAxisMarker = [SCIAxisMarkerAnnotation new];
    _smaAxisMarker.position = SCIGeneric(0);
    _smaAxisMarker.style.backgroundColor = [UIColor fromARGBColorCode:SmaSeriesColor];
    
    _ohlcAxisMarker = [SCIAxisMarkerAnnotation new];
    _ohlcAxisMarker.position = SCIGeneric(0);
    _ohlcAxisMarker.style.backgroundColor = [UIColor fromARGBColorCode:StrokeUpColor];
    
    SCIZoomPanModifier * zoomPanModifier = [SCIZoomPanModifier new];
    zoomPanModifier.direction = SCIDirection2D_XDirection;
    
    SCILegendModifier * legendModifier = [SCILegendModifier new];
    legendModifier.orientation = SCIOrientationHorizontal;
    legendModifier.position = SCILegendPositionBottom;
    
    [SCIUpdateSuspender usingWithSuspendable:self.mainSurface withBlock:^{
        [self.mainSurface.xAxes add:xAxis];
        [self.mainSurface.yAxes add:yAxis];
        [self.mainSurface.renderableSeries add:ma50Series];
        [self.mainSurface.renderableSeries add:ohlcSeries];
        [self.mainSurface.annotations add:_smaAxisMarker];
        [self.mainSurface.annotations add:_ohlcAxisMarker];
        
        self.mainSurface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIXAxisDragModifier new], zoomPanModifier, [SCIZoomExtentsModifier new], legendModifier]];
        [SCIThemeManager applyDefaultThemeToThemeable:self.mainSurface];
    }];
}

- (void)createOverviewChartWithLeftAnnotation:(SCIBoxAnnotation *)leftAreaAnnotation RightAnnotation:(SCIBoxAnnotation *)rightAreaAnnotation {
    id<SCIAxis2DProtocol> xAxis = [SCICategoryDateTimeAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = _ohlcDataSeries;
    mountainSeries.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0x883a668f finish:0xff20384f direction:SCILinearGradientDirection_Vertical];
    
    leftAreaAnnotation.coordinateMode = SCIAnnotationCoordinate_RelativeY;
    leftAreaAnnotation.y1 = SCIGeneric(0);
    leftAreaAnnotation.y2 = SCIGeneric(1);
    leftAreaAnnotation.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FFFFFF];
    
    rightAreaAnnotation.coordinateMode = SCIAnnotationCoordinate_RelativeY;
    rightAreaAnnotation.y1 = SCIGeneric(0);
    rightAreaAnnotation.y2 = SCIGeneric(1);
    rightAreaAnnotation.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FFFFFF];
    
    [SCIUpdateSuspender usingWithSuspendable:self.overviewSurface withBlock:^{
        [self.overviewSurface.xAxes add:xAxis];
        [self.overviewSurface.yAxes add:yAxis];
        [self.overviewSurface.renderableSeries add:mountainSeries];
        [self.overviewSurface.annotations add:leftAreaAnnotation];
        [self.overviewSurface.annotations add:rightAreaAnnotation];
        
        [SCIThemeManager applyDefaultThemeToThemeable:self.overviewSurface];
    }];
}

- (void)onNewPrice:(PriceBar *)price {
    double smaLastValue;
    if (_lastPrice.date == price.date) {
        [_ohlcDataSeries updateAt:_ohlcDataSeries.count - 1 Open:SCIGeneric(price.open) High:SCIGeneric(price.high) Low:SCIGeneric(price.low) Close:SCIGeneric(price.close)];
        
        smaLastValue = [_sma50 update:price.close].current;
        [_xyDataSeries updateAt:_xyDataSeries.count - 1 Y:SCIGeneric(smaLastValue)];
    } else {
        [_ohlcDataSeries appendX:SCIGeneric(price.date) Open:SCIGeneric(price.open) High:SCIGeneric(price.high) Low:SCIGeneric(price.low) Close:SCIGeneric(price.close)];
        
        smaLastValue = [_sma50 push:price.close].current;
        [_xyDataSeries appendX:SCIGeneric(price.date) Y:SCIGeneric(smaLastValue)];
 
        id<SCIRangeProtocol> visibleRange = self.mainSurface.xAxes[0].visibleRange;
        if (visibleRange.maxAsDouble > _ohlcDataSeries.count) {
            [visibleRange setMinTo:SCIGeneric(visibleRange.minAsDouble + 1) MaxTo:SCIGeneric(visibleRange.maxAsDouble + 1)];
        }
    }
    
    _ohlcAxisMarker.style.backgroundColor = price.close >= price.open ? [UIColor fromARGBColorCode:StrokeUpColor] : [UIColor fromARGBColorCode:StrokeDownColor];
    _ohlcAxisMarker.position = SCIGeneric(price.close);
    _smaAxisMarker.position = SCIGeneric(smaLastValue);
    
    _lastPrice = price;
}

- (void)subscribePriceUpdate {
    [_marketDataService subscribePriceUpdate:onNewPriceBlock];
}

- (void)clearSubscribtions {
    [_marketDataService clearSubscriptions];
}

- (void)changeSeriesType {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Series type" message:@"Select series type for the top scichart surface" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"CandlestickRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self changeSeries:[SCIFastCandlestickRenderableSeries new]];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OhlcRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self changeSeries:[SCIFastOhlcRenderableSeries new]];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"MountainRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self changeSeries:[SCIFastMountainRenderableSeries new]];
    }]];
    
    UIViewController * topVC = UIApplication.sharedApplication.delegate.window.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:alertController animated:YES completion:nil];
}

- (void)changeSeries:(SCIRenderableSeriesBase *)rSeries {
    rSeries.dataSeries = _ohlcDataSeries;
    
    [SCIUpdateSuspender usingWithSuspendable:self.mainSurface withBlock:^{
        [self.mainSurface.renderableSeries removeAt:1];
        [self.mainSurface.renderableSeries add:rSeries];
        [SCIThemeManager applyDefaultThemeToThemeable:rSeries];
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if (newWindow == nil) {
        [_marketDataService clearSubscriptions];
    }
}
                                                         
@end
