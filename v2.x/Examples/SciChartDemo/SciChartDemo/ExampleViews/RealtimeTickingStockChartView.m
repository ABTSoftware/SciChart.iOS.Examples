//
//  RealtimeTickingStockChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 7/19/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "RealtimeTickingStockChartView.h"
#import "UIAlertController+SCDAdditional.h"
#import "RealTimeTickingStocksControlPanelView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface RealtimeTickingStockChartView() {
    SCIMultiSurfaceModifier * szpm;
    SCIMultiSurfaceModifier *szem;
    SCIMultiSurfaceModifier *spzm;
    SCIOhlcDataSeries * ohlcDataSeries;
    SCIXyDataSeries * avgDataSeries;
    SCIXyDataSeries * mountainDataSeries;
    id<SCIAxis2DProtocol> xAxis;
    SCIRenderableSeriesBase *renderableSeries;
    SCIRenderableSeriesBase *avgRenderableSeries;
    
    MarketDataService *_marketDataService;
    SCDMovingAverage *msa;
    SCDMultiPaneItem *_lastPrice;
    SCIBoxAnnotation * box;
    NSTimer *timer;
    int counter;
    int seriesCount;
    int countUpdater;
    
    SCIAxisMarkerAnnotation * _lastMarker;
    UIColor * _lastUpColor;
    UIColor * _lastDownColor;
    SCIAxisMarkerAnnotation * _averageMarker;
    
    BOOL drawZoomRectangle;
}

@property (nonatomic, weak) SCIChartSurfaceView * sciChartView1;
@property (nonatomic, weak) SCIChartSurfaceView * sciChartView2;

@property (nonatomic, strong) SCIChartSurface * surface1;
@property (nonatomic, strong) SCIChartSurface * surface2;

@end

@implementation RealtimeTickingStockChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        //Initializing first top scichart view
        
        SCIChartSurfaceView *view = [[SCIChartSurfaceView alloc]init];
        _sciChartView1 = view;
        
        [_sciChartView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView1];
        
        //Initializing first bottom scichart view
        
        view = [[SCIChartSurfaceView alloc]init];
        _sciChartView2 = (SCIChartSurfaceView*)view;
        
        [_sciChartView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView2];
        
        __weak typeof(self) wSelf = self;
        
        //Initializing first top control view
        
        RealTimeTickingStocksControlPanelView * panel = (RealTimeTickingStocksControlPanelView*)[[[NSBundle mainBundle] loadNibNamed:@"RealTimeTickingStocksControlPanel" owner:self options:nil] firstObject];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        
        //Subscribing to the control view events
        
        panel.continueTickingTouched = ^(UIButton *sender) { [wSelf continueTicking]; };
        panel.pauseTickingTouched = ^(UIButton *sender) { [wSelf pauseTicking]; };
        panel.seriesTypeTouched = ^(UIButton *sender) { [wSelf changeSeriesType:sender]; };
        
        [self addSubview:panel];
        
        NSDictionary *layout = @{@"SciChart1": _sciChartView1, @"SciChart2": _sciChartView2, @"Panel": panel};
        
        //Adding constraints for views' layout
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart1]-(5)-[SciChart2(100)]-(0)-|" options:0 metrics:0 views:layout]];
        
        counter = 0;
        seriesCount = 60;
        countUpdater = seriesCount;
        
        msa = [[SCDMovingAverage alloc] initWithLength:50];
        
        NSDate *initialDate = [NSDate dateWithTimeIntervalSinceNow:500];
        
        _marketDataService = [[MarketDataService alloc]initWithStartDate: initialDate TimeFrameMinutes:500 TickTimerIntervals:0.1];
        NSMutableArray *prices = [_marketDataService getHistoricalData:seriesCount];
        
        ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
        ohlcDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
        for (int i=0; i<prices.count; i++) {
            SCDMultiPaneItem *item = prices[i];
            [ohlcDataSeries appendX:SCIGeneric(item.dateTime) Open:SCIGeneric(item.open) High:SCIGeneric(item.high) Low:SCIGeneric(item.low) Close:SCIGeneric(item.close)];
        }
        
        avgDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
        avgDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
        for (int i=0; i<prices.count; i++) {
            SCDMultiPaneItem *item = prices[i];
            [avgDataSeries appendX:SCIGeneric(item.dateTime) Y:SCIGeneric([msa push:(item.close)].current)];
            _lastPrice = item;
        }
        
        [self prepare];
        [self initializeTopSurfaceData];
        [self initializeBottomSurfaceData];
        
        [self continueTicking];
    }
    
    return self;
}

-(void) changeSeriesType:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Series type" message:@"Select series type for the top scichart surface" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"CandlestickRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [_surface1.renderableSeries add: renderableSeries];
        [self updateToCandlestickRenderableSeries];
        [self updateRenderableSeriesType];
    }];
    [alertController addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"OhlcRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [_surface1.renderableSeries add: renderableSeries];
        [self updateToOhlcRenderableSeries];
        [self updateRenderableSeriesType];
    }];
    [alertController addAction:action];
    
    action = [UIAlertAction actionWithTitle:@"MountainRenderableSeries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [_surface1.renderableSeries add: renderableSeries];
        [self updateToMountainRenderableSeries];
        [self updateRenderableSeriesType];
    }];
    [alertController addAction:action];
    
    alertController.popoverPresentationController.sourceRect = sender.bounds;
    alertController.popoverPresentationController.sourceView = sender;
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController :alertController animated:YES completion:nil];
}

-(void) updateRenderableSeriesType{
    [_surface1.renderableSeries add: avgRenderableSeries];
    [_surface1.renderableSeries add: renderableSeries];
    [_surface1.renderableSeries add: avgRenderableSeries];
    [_surface1 invalidateElement];
}

- (UIViewController *)currentTopViewController{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void) continueTicking{
    if(timer)
        return;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(updateData:)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        [self pauseTicking];
    }
}

-(void) pauseTicking{
    [timer invalidate];
    timer = nil;
}

-(void)updateData:(NSTimer *)timer{
    
    SCDMultiPaneItem *price = [_marketDataService getNextBar];
    
    if(_lastPrice != nil && _lastPrice.dateTime == price.dateTime){ // TODO: compare dates in proper way
        [ohlcDataSeries updateAt:ohlcDataSeries.count-1 X:SCIGeneric(price.dateTime) Open:SCIGeneric(price.open) High:SCIGeneric(price.high) Low:SCIGeneric(price.low) Close:SCIGeneric(price.close)];
        [msa update:price.close];
        [avgDataSeries updateAt:avgDataSeries.count-1 X:SCIGeneric(price.dateTime) Y:SCIGeneric(msa.current) ];
        [mountainDataSeries updateAt:mountainDataSeries.count-1 X:SCIGeneric(price.dateTime) Y:SCIGeneric(price.high)];
    }
    else{
        
        [ohlcDataSeries appendX:SCIGeneric(price.dateTime) Open:SCIGeneric(price.open) High:SCIGeneric(price.high) Low:SCIGeneric(price.low) Close:SCIGeneric(price.close)];
        
        [avgDataSeries appendX:SCIGeneric(price.dateTime) Y:SCIGeneric([msa push:price.close].current) ];
        
        [mountainDataSeries appendX:SCIGeneric(price.dateTime) Y:SCIGeneric(price.high)];
        
        double visibleRangeMax = SCIGenericDate([xAxis.visibleRange max]).timeIntervalSince1970;
        double lastItem = SCIGenericDate([[ohlcDataSeries xValues] valueAt:ohlcDataSeries.count-1]).timeIntervalSince1970;
        
        if ( visibleRangeMax >= lastItem ) {
            double priorItem = SCIGenericDate([[ohlcDataSeries xValues] valueAt:ohlcDataSeries.count-2]).timeIntervalSince1970;
            double visibleRangeMin = SCIGenericDate([xAxis.visibleRange min]).timeIntervalSince1970;
            double leftItem = SCIGenericDate([[ohlcDataSeries xValues] valueAt:0]).timeIntervalSince1970;
            
            double min;
            
            if (visibleRangeMin >= leftItem) {
                min = visibleRangeMin + (lastItem-priorItem);
            } else {
                min = visibleRangeMin + (lastItem-priorItem);
            }
            [xAxis setVisibleRange: [[SCIDateRange alloc] initWithMin:SCIGeneric(min) Max:SCIGeneric(lastItem + (visibleRangeMax-priorItem))]];
        }
    }
    
    _lastMarker.position = SCIGeneric(price.close);
    if (price.close > price.open) {
        _lastMarker.style.backgroundColor = _lastUpColor;
    } else {
        _lastMarker.style.backgroundColor = _lastDownColor;
    }
    _averageMarker.position = SCIGeneric(msa.current);
    
    _lastPrice = price;
    [_surface1 invalidateElement];
    [_surface2 invalidateElement];
    
    [self drawBoxAnnotation];
}

-(void) prepare {
    
    //Initializing SciChart Modifiers
    
    szpm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomPanModifier class]];
    szem = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomExtentsModifier class]];
    spzm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIPinchZoomModifier class]];
    
    
    //Initializing top scichart surface
    
    _surface1 = [[SCIChartSurface alloc] initWithView: _sciChartView1];
    [[_surface1 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface1 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    //Initializing bottom scichart surface
    
    _surface2 = [[SCIChartSurface alloc] initWithView: _sciChartView2];
    [[_surface2 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface2 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    box = [[SCIBoxAnnotation alloc] init];
    box.xAxisId = @"X2";
    box.yAxisId = @"Y2";
    box.coordinateMode = SCIAnnotationCoordinate_RelativeY;
    box.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x200070FF];
    [_surface2 setAnnotation:box];
}

-(void) initializeTopSurfaceData {
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    SCITextFormattingStyle *  textFormatting = [[SCITextFormattingStyle alloc] init];
    
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    //Initializing axes and attaching them to the surface
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"Y1";
    [axis setCursorTextFormatting:@"%.02f"];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAutoRange:SCIAutoRange_Always];
    [_surface1.yAxes add:axis];
    
    xAxis = [[SCIDateTimeAxis alloc] init];
    xAxis.axisId = @"X1";
    
    double priorItem = SCIGenericDate([[ohlcDataSeries xValues] valueAt:ohlcDataSeries.count-2]).timeIntervalSince1970;
    double lastItem = SCIGenericDate([[ohlcDataSeries xValues] valueAt:ohlcDataSeries.count-1]).timeIntervalSince1970;
    
    [xAxis setVisibleRange: [[SCIDateRange alloc] initWithMin:[[ohlcDataSeries xValues] valueAt:0]
                                                          Max:SCIGeneric(lastItem + (lastItem-priorItem))]];
    [((SCIDateTimeAxis*)xAxis) setTextFormatting:@"dd/MM/yyyy"];
    [xAxis setStyle: axisStyle];
    [xAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.1)]];
    [_surface1.xAxes add:xAxis];
    
    //Creating SciChart modifiers
    
    SCIAxisPinchZoomModifier * x1Pinch = [SCIAxisPinchZoomModifier new];
    x1Pinch.axisId = @"X1";
    [x1Pinch setModifierName:@"X1 Axis Pinch Modifier"];
    
    SCIXAxisDragModifier * x1Drag = [SCIXAxisDragModifier new];
    x1Drag.axisId = @"X1";
    x1Drag.dragMode = SCIAxisDragMode_Scale;
    x1Drag.clipModeX = SCIZoomPanClipMode_None;
    [x1Drag setModifierName:@"X1 Axis Drag Modifier"];
    
    SCIAxisPinchZoomModifier * y1Pinch = [SCIAxisPinchZoomModifier new];
    y1Pinch.axisId = @"Y1";
    [y1Pinch setModifierName:@"Y1 Axis Pinch Modifier"];
    
    SCIYAxisDragModifier * y1Drag = [SCIYAxisDragModifier new];
    y1Drag.axisId = @"Y1";
    y1Drag.dragMode = SCIAxisDragMode_Pan;
    [y1Drag setModifierName:@"Y1 Axis Drag Modifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    [zpm setModifierName:@"PanZoom Modifier"];
    
    //Initializing modifiers group and attaching it to the scichart surface
    
    SCIZoomPanModifier *zommPanModifier = [szpm modifierForSurface:_surface1];
    zommPanModifier.xyDirection = SCIXYDirection_XDirection;
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[x1Pinch, y1Pinch, x1Drag, y1Drag, spzm, szem, szpm]];
    _surface1.chartModifier = gm;
    
    
    [_surface1.renderableSeries add:[self getOhlcRenderableSeries:false
                                                        upBodyBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFff9c0f]
                                                      downBodyBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFffff66]
                                                              count:seriesCount]];
    
    [_surface1.renderableSeries add:[self getAverageLine]];
    
    _lastUpColor = [UIColor fromABGRColorCode:0xFFa64044];
    _lastDownColor = [UIColor fromABGRColorCode:0xFF3da13b];
    
    _lastMarker = [[SCIAxisMarkerAnnotation alloc] init];
    _lastMarker.yAxisId = @"Y1";
    _lastMarker.coordinateMode = SCIAnnotationCoordinate_Absolute;
    _lastMarker.style.backgroundColor = _lastUpColor;
    
    _averageMarker = [[SCIAxisMarkerAnnotation alloc] init];
    _averageMarker.yAxisId = @"Y1";
    _averageMarker.coordinateMode = SCIAnnotationCoordinate_Absolute;
    _averageMarker.style.backgroundColor = [UIColor fromABGRColorCode:0xFFffa500];
    
    _surface1.annotation = [[SCIAnnotationCollection alloc] initWithChildAnnotations:@[_averageMarker, _lastMarker]];
    
    [_surface1 invalidateElement];
}

-(void) initializeBottomSurfaceData {
    
    //Creating axes and attaching them to the scichart surface
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"Y2";
    axis.style.drawMajorGridLines = false;
    axis.isVisible = false;
    [axis setAutoRange:SCIAutoRange_Always];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_surface2.yAxes add:axis];
    
    axis = [[SCIDateTimeAxis alloc] init];
    axis.axisId = @"X2";
    [axis setAutoRange:SCIAutoRange_Always];
    [((SCIDateTimeAxis*)axis) setTextFormatting:@"dd/MM/yyyy"];
    axis.style.drawMajorGridLines = false;
    axis.isVisible = false;
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(0.1)]];
    [_surface2.xAxes add:axis];
    
    //Creating modifiers and attaching them to the scichart surface
    
    SCIAxisPinchZoomModifier * x2Pinch = [SCIAxisPinchZoomModifier new];
    x2Pinch.axisId = @"X2";
    [x2Pinch setModifierName:@"Y2 Axis Pinch Modifier"];
    
    SCIXAxisDragModifier * x2Drag = [SCIXAxisDragModifier new];
    x2Drag.axisId = @"X2";
    x2Drag.dragMode = SCIAxisDragMode_Scale;
    x2Drag.clipModeX = SCIZoomPanClipMode_None;
    [x2Drag setModifierName:@"Y2 Axis Drag Modifier"];
    
    SCIAxisPinchZoomModifier * y2Pinch = [SCIAxisPinchZoomModifier new];
    y2Pinch.axisId = @"Y2";
    [y2Pinch setModifierName:@"X2 Axis Pinch Modifier"];
    
    SCIYAxisDragModifier * y2Drag = [SCIYAxisDragModifier new];
    y2Drag.axisId = @"Y2";
    y2Drag.dragMode = SCIAxisDragMode_Pan;
    [y2Drag setModifierName:@"X2 Axis Drag Modifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    [zpm setModifierName:@"PanZoom Modifier"];
    
    //Initializing modifiers group here and attaching to the surface
    
    SCIZoomPanModifier *zoomPanModifier = [szpm modifierForSurface:_surface2];
    zoomPanModifier.xyDirection = SCIXYDirection_XDirection;
    
    SCIZoomPanModifier *pinchZoomModifier = [spzm modifierForSurface:_surface2];
    pinchZoomModifier.xyDirection = SCIXYDirection_XDirection;
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[szpm, spzm]];
    _surface2.chartModifier = gm;
    
    SCIBrushStyle *brush = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0x883a668f
                                                                           finish:0xff20384f
                                                                        direction:SCILinearGradientDirection_Vertical];
    
    SCIPenStyle *pen = [[SCISolidPenStyle alloc] initWithColorCode:0xff3a668f withThickness:0.5];
    
    //Attaching Renderable Series
    
    [_surface2.renderableSeries add:[self getMountainRenderableSeries:brush borderPen:pen]];
    
    [_surface2 invalidateElement];
}

-(SCIFastCandlestickRenderableSeries*) getOhlcRenderableSeries:(bool) isRevered
                                                   upBodyBrush:(SCISolidBrushStyle*) upBodyColor
                                                 downBodyBrush:(SCISolidBrushStyle*) downBodyColor
                                                         count:(int) count{
    
    renderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    renderableSeries.xAxisId = @"X1";
    renderableSeries.yAxisId = @"Y1";
    [renderableSeries setDataSeries: ohlcDataSeries];
    
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFa64044 withThickness:1.0];
    
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF3da13b withThickness:1.0];
    
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFa64044];
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF3da13b];
    
    return ((SCIFastCandlestickRenderableSeries*)renderableSeries);
}

-(SCIFastLineRenderableSeries *) getAverageLine{
    avgRenderableSeries = [SCIFastLineRenderableSeries new];
    [((SCIFastLineRenderableSeries*)avgRenderableSeries).style setLinePen: [[SCISolidPenStyle alloc] initWithColorCode:0xFFffa500 withThickness:1.0]];
    [((SCIFastLineRenderableSeries*)avgRenderableSeries) setXAxisId: @"X1"];
    [((SCIFastLineRenderableSeries*)avgRenderableSeries) setYAxisId: @"Y1"];
    [((SCIFastLineRenderableSeries*)avgRenderableSeries) setDataSeries:avgDataSeries];
    
    return ((SCIFastLineRenderableSeries*)avgRenderableSeries);
}

-(SCIFastMountainRenderableSeries*) getMountainRenderableSeries:(SCIBrushStyle*) areaBrush borderPen:(SCIPenStyle*) borderPen {
    mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    mountainDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    for (int i=0 ;i<ohlcDataSeries.count; i++) {
        [mountainDataSeries appendX:SCIGeneric([ohlcDataSeries.xValues valueAt:i].doubleData)
                                  Y:SCIGeneric([ohlcDataSeries.highValues valueAt:i].floatData)];
    }
    
    SCIFastMountainRenderableSeries * mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.style.areaBrush = areaBrush;
    mountainRenderableSeries.style.borderPen = borderPen;
    
    mountainRenderableSeries.xAxisId = @"X2";
    mountainRenderableSeries.yAxisId = @"Y2";
    [mountainRenderableSeries setDataSeries:mountainDataSeries];
    
    return mountainRenderableSeries;
}

-(void) updateToCandlestickRenderableSeries{
    renderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    
    renderableSeries.xAxisId = @"X1";
    renderableSeries.yAxisId = @"Y1";
    [renderableSeries setDataSeries: ohlcDataSeries];
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.drawBorders = NO;
    
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFa64044 withThickness:1.0];
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF3da13b withThickness:1.0];
    
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFa64044];
    ((SCIFastCandlestickRenderableSeries*)renderableSeries).style.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF3da13b];
}

-(void) updateToMountainRenderableSeries{
    renderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    
    
    SCIBrushStyle *brush = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0x883a668f
                                                                           finish:0xff20384f
                                                                        direction:SCILinearGradientDirection_Vertical];
    
    SCIPenStyle *pen = [[SCISolidPenStyle alloc] initWithColorCode:0xffc6e6ff withThickness:0.5];
    
    ((SCIFastMountainRenderableSeries*)renderableSeries).style.areaBrush = brush;
    ((SCIFastMountainRenderableSeries*)renderableSeries).style.borderPen = pen;
    
    renderableSeries.xAxisId = @"X1";
    renderableSeries.yAxisId = @"Y1";
    [renderableSeries setDataSeries:ohlcDataSeries];
}

-(void) updateToOhlcRenderableSeries{
    renderableSeries = [[SCIFastOhlcRenderableSeries alloc] init];
    
    renderableSeries.xAxisId = @"X1";
    renderableSeries.yAxisId = @"Y1";
    [renderableSeries setDataSeries: ohlcDataSeries];
    
    ((SCIFastOhlcRenderableSeries*)renderableSeries).style.upWickPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFa64044 withThickness:1.0];
    
    ((SCIFastOhlcRenderableSeries*)renderableSeries).style.downWickPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF3da13b withThickness:1.0];
}

-(void) drawBoxAnnotation{
    box.isEnabled = false;
    
    box.x1 = [xAxis.visibleRange min];
    box.x2 = [xAxis.visibleRange max];
    
    box.y1 = SCIGeneric(0);
    box.y2 = SCIGeneric(1);
}


@end
