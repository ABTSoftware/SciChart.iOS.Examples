//
//  RealtimeTickingStockChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/19/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "RealtimeTickingStockChartView.h"
#import "RealTimeTickingStocksControlPanelView.h"
#import <SciChart/SciChart.h>
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
    UIAlertController * _alertController;
    
    SCIChartSurface * _mainSurface;
    SCIChartSurface * _overviewSurface;

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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _mainSurface = [SCIChartSurface new];
        _mainSurface.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_mainSurface];
        
        _overviewSurface = [SCIChartSurface new];
        _overviewSurface.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_overviewSurface];
        
        __weak typeof(self) wSelf = self;
        
        RealTimeTickingStocksControlPanelView * panel = (RealTimeTickingStocksControlPanelView *)[[NSBundle mainBundle] loadNibNamed:@"RealTimeTickingStocksControlPanel" owner:self options:nil].firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:panel];
        
        onNewPriceBlock = ^(PriceBar * price) {
            [wSelf onNewPrice:price];
        };
        
        panel.continueTickingTouched = ^(UIButton *sender) { [_marketDataService subscribePriceUpdate:onNewPriceBlock]; };
        panel.pauseTickingTouched = ^(UIButton *sender) { [_marketDataService clearSubscriptions]; };
        panel.seriesTypeTouched = ^(UIButton *sender) { [wSelf changeSeriesType:sender]; };
        
        NSDictionary * layout = @{@"SciChart1": _mainSurface, @"SciChart2": _overviewSurface, @"Panel": panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart1]-(5)-[SciChart2(100)]-(0)-|" options:0 metrics:0 views:layout]];

        _alertController = [UIAlertController alertControllerWithTitle:@"Series type" message:@"Select series type for the top scichart surface" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"CandlestickRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self changeSeries:[SCIFastCandlestickRenderableSeries new]];
        }]];
        
        [_alertController addAction:[UIAlertAction actionWithTitle:@"OhlcRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self changeSeries:[SCIFastOhlcRenderableSeries new]];
        }]];
        
        [_alertController addAction:[UIAlertAction actionWithTitle:@"MountainRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self changeSeries:[SCIFastMountainRenderableSeries new]];
        }]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    _marketDataService = [[MarketDataService alloc] initWithStartDate:[NSDate dateWithYear:2000 month:8 day:01 hour:12 minute:0 second:0] TimeFrameMinutes:5 TickTimerIntervals:0.02];
    _sma50 = [[MovingAverage alloc] initWithLength:50];
    
    [self initDataWithService:_marketDataService];

    [self createMainPriceChart];
    SCIBoxAnnotation * leftAreaAnnotation = [SCIBoxAnnotation new];
    SCIBoxAnnotation * rightAreaAnnotation = [SCIBoxAnnotation new];
    
    [self createOverviewChartWithLeftAnnotation:leftAreaAnnotation RightAnnotation:rightAreaAnnotation];
    
    SCIAxisBase * axis = (SCIAxisBase *)[_mainSurface.xAxes itemAt:0];
    [axis registerVisibleRangeChangedCallback:^(id<SCIRangeProtocol> newRange, id<SCIRangeProtocol> oldRange, BOOL isAnimated, id sender) {
        leftAreaAnnotation.x1 = [_overviewSurface.xAxes itemAt:0].visibleRange.asDoubleRange.min;
        leftAreaAnnotation.x2 = [_mainSurface.xAxes itemAt:0].visibleRange.asDoubleRange.min;
        
        rightAreaAnnotation.x1 = [_mainSurface.xAxes itemAt:0].visibleRange.asDoubleRange.max;
        rightAreaAnnotation.x2 = [_overviewSurface.xAxes itemAt:0].visibleRange.asDoubleRange.max;
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
    [_xyDataSeries appendRangeX:SCIGeneric(prices.dateData) Y:SCIGeneric((double*)movingAverageArray) Count:prices.size];
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
    _smaAxisMarker.yAxisId = yAxis.axisId;
    _smaAxisMarker.style.backgroundColor = [UIColor fromARGBColorCode:SmaSeriesColor];
    
    _ohlcAxisMarker = [SCIAxisMarkerAnnotation new];
    _ohlcAxisMarker.position = SCIGeneric(0);
    _ohlcAxisMarker.yAxisId = yAxis.axisId;
    _ohlcAxisMarker.style.backgroundColor = [UIColor fromARGBColorCode:StrokeUpColor];
    
    SCIZoomPanModifier * zoomPanModifier = [SCIZoomPanModifier new];
    zoomPanModifier.direction = SCIDirection2D_XDirection;
    
    SCILegendModifier * legendModifier = [SCILegendModifier new];
    legendModifier.orientation = SCIOrientationHorizontal;
    legendModifier.position = SCILegendPositionBottom;
    // TODO consider removing item cell style
    legendModifier.styleOfItemCell = [SCILegendCellStyle new];
    legendModifier.styleOfItemCell.seriesNameFont = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    [SCIUpdateSuspender usingWithSuspendable:_mainSurface withBlock:^{
        [_mainSurface.xAxes add:xAxis];
        [_mainSurface.yAxes add:yAxis];
        [_mainSurface.renderableSeries add:ma50Series];
        [_mainSurface.renderableSeries add:ohlcSeries];
        [_mainSurface.annotations add:_smaAxisMarker];
        [_mainSurface.annotations add:_ohlcAxisMarker];
        
        _mainSurface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIXAxisDragModifier new], zoomPanModifier, [SCIZoomExtentsModifier new], legendModifier]];
        [SCIThemeManager applyDefaultThemeToThemeable:_mainSurface];
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
    
    [SCIUpdateSuspender usingWithSuspendable:_overviewSurface withBlock:^{
        [_overviewSurface.xAxes add:xAxis];
        [_overviewSurface.yAxes add:yAxis];
        [_overviewSurface.renderableSeries add:mountainSeries];
        [_overviewSurface.annotations add:leftAreaAnnotation];
        [_overviewSurface.annotations add:rightAreaAnnotation];
        
        [SCIThemeManager applyDefaultThemeToThemeable:_overviewSurface];
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
 
        SCICategoryDateTimeAxis * xAxis = (SCICategoryDateTimeAxis *)[_mainSurface.xAxes itemAt:0];
        SCIDoubleRange * visibleRange = [xAxis.visibleRange asDoubleRange];
        if (SCIGenericDouble(visibleRange.max) > _ohlcDataSeries.count) {
            [_mainSurface.xAxes itemAt:0].visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(SCIGenericDouble(visibleRange.min) + 1) Max:SCIGeneric(SCIGenericDouble(visibleRange.max) + 1)];
        }
    }
    
    _ohlcAxisMarker.style.backgroundColor = price.close >= price.open ? [UIColor fromARGBColorCode:StrokeUpColor] : [UIColor fromARGBColorCode:StrokeDownColor];
    _ohlcAxisMarker.position = SCIGeneric(price.close);
    _smaAxisMarker.position = SCIGeneric(smaLastValue);
    
    _lastPrice = price;
}

- (void)changeSeriesType:(UIButton *)sender {
    _alertController.popoverPresentationController.sourceRect = sender.bounds;
    _alertController.popoverPresentationController.sourceView = sender;

    UIViewController * topVC = UIApplication.sharedApplication.delegate.window.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:_alertController animated:YES completion:nil];
}

- (void)changeSeries:(SCIRenderableSeriesBase *)rSeries {
    rSeries.dataSeries = _ohlcDataSeries;
    
    [SCIUpdateSuspender usingWithSuspendable:_mainSurface withBlock:^{
        [_mainSurface.renderableSeries removeAt:1];
        [_mainSurface.renderableSeries add:rSeries];
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
