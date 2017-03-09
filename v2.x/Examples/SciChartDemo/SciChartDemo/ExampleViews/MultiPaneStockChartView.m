//
//  MultiPaneStockChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 7/18/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "MultiPaneStockChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import <math.h>

@interface MultiPaneStockChartView ()

@property (nonatomic, weak) SCIChartSurfaceView * sciChartView1;
@property (nonatomic, weak) SCIChartSurfaceView * sciChartView2;
@property (nonatomic, weak) SCIChartSurfaceView * sciChartView3;
@property (nonatomic, weak) SCIChartSurfaceView * sciChartView4;
@property (nonatomic, strong) SCIChartSurface * surface1;
@property (nonatomic, strong) SCIChartSurface * surface2;
@property (nonatomic, strong) SCIChartSurface * surface3;
@property (nonatomic, strong) SCIChartSurface * surface4;
@property SCIMultiSurfaceModifier *szem;
@property (nonatomic) NSArray <SCDMultiPaneItem*> *dataSource;
@property NSMutableDictionary *dataSeries;
@property SCIAxisRangeSyncronization *rangeSync;
@property SCIAxisAreaSizeSyncronization *axisAreaSizeSync;

@end

@implementation MultiPaneStockChartView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _rangeSync = [SCIAxisRangeSyncronization new];
        _axisAreaSizeSync = [SCIAxisAreaSizeSyncronization new];
        _axisAreaSizeSync.syncMode = SCIAxisSizeSync_Right;
        _dataSource = [DataManager loadPaneStockData];
        [self generateDataSeries];
        
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        _sciChartView1 = view;
        [_sciChartView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView1];
        
        view = [[SCIChartSurfaceView alloc]init];
        _sciChartView2 = (SCIChartSurfaceView*)view;
        [_sciChartView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView2];
        
        view = [[SCIChartSurfaceView alloc]init];
        _sciChartView3 = (SCIChartSurfaceView*)view;
        [_sciChartView3 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView3];
        
        view = [[SCIChartSurfaceView alloc]init];
        _sciChartView4 = (SCIChartSurfaceView*)view;
        [_sciChartView4 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_sciChartView4];
        
        
        NSDictionary *layout = @{@"SciChart1":_sciChartView1, @"SciChart2":_sciChartView2, @"SciChart3":_sciChartView3, @"SciChart4":_sciChartView4};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart3]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart4]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart1]-(0)-[SciChart2(SciChart3)]-(0)-[SciChart3(SciChart2)]-(0)-[SciChart4(SciChart3)]-(0)-|"
                                                                     options:0
                                                                     metrics:0
                                                                       views:layout]];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_sciChartView1
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:0
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeHeight
                                                                     multiplier:.5
                                                                       constant:0];
        [self addConstraint:constraint];
        
        
        [self prepare];
        
    }
    
    return self;
}

- (void)prepare {
    self.szem = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomExtentsModifier class]];
    
    _surface1 = [[SCIChartSurface alloc] initWithView: _sciChartView1];
    [[_surface1 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface1 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    _surface2 = [[SCIChartSurface alloc] initWithView: _sciChartView2];
    [[_surface2 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface2 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    _surface3 = [[SCIChartSurface alloc] initWithView: _sciChartView3];
    [[_surface3 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface3 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    _surface4 = [[SCIChartSurface alloc] initWithView: _sciChartView4];
    [[_surface4 style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[_surface4 style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    [self setupSurface:_surface1 showXAxis:YES];
    [self setupSurface:_surface2 showXAxis:NO];
    [self setupSurface:_surface3 showXAxis:NO];
    [self setupSurface:_surface4 showXAxis:NO];
    
    [_surface1.renderableSeries add:[self generateLineSeries]];
    [_surface1.renderableSeries add:[self generateLineSeries1]];
    [_surface1.renderableSeries add:[self generateCandleStick]];
    [self p_addTextAnnotation:@" EUR/USD" forSurface:_surface1];
    [_surface1 invalidateElement];
    
    
    [_surface2.renderableSeries add:[self generateBandSeries]];
    [_surface2.renderableSeries add:[self generateColumnSeries]];
    [self p_addTextAnnotation:@" MACD" forSurface:_surface2];
    [_surface2 invalidateElement];
    
    [_surface3.renderableSeries add:[self generateLineSeries2]];
    [self p_addTextAnnotation:@" RSI" forSurface:_surface3];
    [_surface3 invalidateElement];
    
    [_surface4.renderableSeries add:[self generateColumnSeries1]];
    [self p_addTextAnnotation:@" Volume" forSurface:_surface4];
    [_surface4 invalidateElement];
    
}

- (void)p_addTextAnnotation:(NSString*)text forSurface:(SCIChartSurface*)surface {
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:14];
    [textFormatting setFontName:@"Arial"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCITextAnnotation * textAnnotation = [[SCITextAnnotation alloc] init];
    textAnnotation.xAxisId = @"X1";
    textAnnotation.yAxisId = @"Y1";
    textAnnotation.coordinateMode = SCIAnnotationCoordinate_Relative;
    textAnnotation.x1 = SCIGeneric(0.03);
    textAnnotation.y1 = SCIGeneric(0.2);
    textAnnotation.text = text;
    textAnnotation.style.textStyle = textFormatting;
    textAnnotation.style.textColor = [UIColor grayColor];
    textAnnotation.style.backgroundColor = [UIColor colorWithRed:22./255. green:33./255. blue:40./255. alpha:1.];
    
    SCIAnnotationCollection * annotationGroup = [[SCIAnnotationCollection alloc]initWithChildAnnotations:@[textAnnotation]];
    [surface setAnnotation:annotationGroup];
}

- (void)setupSurface:(SCIChartSurface*)surface showXAxis:(BOOL)showXAxis {
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    SCITextFormattingStyle *  textFormatting = [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:12];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
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
    [axis setAutoRange:SCIAutoRange_Always];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_axisAreaSizeSync attachSurface:surface];
    [surface.yAxes add:axis];
    
    if (surface == _surface4) {
        SCINumericAxis *numericAxis = (SCINumericAxis*)axis;
        numericAxis.numberFormatter =  [[NSNumberFormatter alloc] init];
        numericAxis.numberFormatter.maximumIntegerDigits = 3;
        numericAxis.numberFormatter.numberStyle = NSNumberFormatterScientificStyle;
        numericAxis.numberFormatter.exponentSymbol = @"E+";
    }
    if (surface == _surface1) {
        [(SCIAxisBase*)axis setTextFormatting:@"$%.4f"];
    }
    else if (surface == _surface2) {
        [(SCIAxisBase*)axis setTextFormatting:@"%.2f"];
    }
    else if (surface == _surface3) {
        [(SCIAxisBase*)axis setTextFormatting:@"%.1f"];
    }
    
    
    axis = [[SCICategoryDateTimeAxis alloc] init];
    axis.axisId = @"X1";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)]];
    [axis.style setDrawMajorBands:YES];
    [axis.style setDrawLabels:showXAxis];
    [axis.style setDrawMajorTicks:showXAxis];
    [axis.style setDrawMinorTicks:NO];
    [axis.style setDrawMinorGridLines:NO];
    [_rangeSync attachAxis:axis];
    [surface.xAxes add:axis];
    
    
    SCIAxisPinchZoomModifier * x1Pinch = [SCIAxisPinchZoomModifier new];
    x1Pinch.axisId = @"X1";
    SCIXAxisDragModifier * x1Drag = [SCIXAxisDragModifier new];
    x1Drag.axisId = @"X1";
    x1Drag.dragMode = SCIAxisDragMode_Scale;
    x1Drag.clipModeX = SCIZoomPanClipMode_None;
    
    SCIAxisPinchZoomModifier * y1Pinch = [SCIAxisPinchZoomModifier new];
    y1Pinch.axisId = @"Y1";
    SCIYAxisDragModifier * y1Drag = [SCIYAxisDragModifier new];
    y1Drag.axisId = @"Y1";
    y1Drag.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    [zpm setModifierName:@"PanZoom Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    [y1Drag setModifierName:@"Y1 Axis Drag Modifier"];
    [x1Drag setModifierName:@"X1 Axis Drag Modifier"];
    
    [y1Pinch setModifierName:@"Y1 Axis Pinch Modifier"];
    [x1Pinch setModifierName:@"X1 Axis Pinch Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[x1Pinch, y1Pinch, x1Drag, y1Drag, pzm, self.szem, zpm]];
    surface.chartModifier = gm;
    
}

- (SCIRenderableSeriesBase*)generateLineSeries {
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColor:[UIColor greenColor] withThickness:0.5]];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:self.dataSeries[@"HighData"]];
    return priceRenderableSeries;
}


- (SCIRenderableSeriesBase*)generateLineSeries1 {
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColor:[UIColor redColor] withThickness:0.5]];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:self.dataSeries[@"LowData"]];
    return priceRenderableSeries;
}

- (SCIRenderableSeriesBase*)generateCandleStick {
    SCIFastCandlestickRenderableSeries * priceRenderableSeries = [SCIFastCandlestickRenderableSeries new];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:self.dataSeries[@"CandleData"]];
    
    priceRenderableSeries.style.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor whiteColor] withThickness:0.5];
    priceRenderableSeries.style.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]];
    
    priceRenderableSeries.style.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:56.f/255.f green:110.f/255.f blue:165.f/255.f alpha:1.f] withThickness:0.5];
    priceRenderableSeries.style.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:56.f/255.f green:110.f/255.f blue:165.f/255.f alpha:1.f]];
    
    return priceRenderableSeries;
}

- (SCIRenderableSeriesBase*)generateLineSeries2 {
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:168.f/255.f green:202.f/255.f blue:230.f/255.f alpha:1.f] withThickness:0.5]];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:self.dataSeries[@"RsiData"]];
    return priceRenderableSeries;
}

- (SCIBandRenderableSeries*)generateBandSeries{
    SCIBandRenderableSeries * bandRenderableSeries = [[SCIBandRenderableSeries alloc] init];
    
    [bandRenderableSeries.style setBrush1:[[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:69.f/255.f green:199.f/255.f blue:66.f/255.f alpha:1.f]]];
    [bandRenderableSeries.style setPen1:[[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:69.f/255.f green:199.f/255.f blue:66.f/255.f alpha:1.f]
                                                                     withThickness:0.5]];
    
    [bandRenderableSeries.style setBrush2:[[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:217.f/255.f green:77.f/255.f blue:82.f/255.f alpha:1.f]]];
    [bandRenderableSeries.style setPen2:[[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:217.f/255.f green:77.f/255.f blue:82.f/255.f alpha:1.f]
                                                                     withThickness:0.5]];
    
    [bandRenderableSeries.style setDrawPointMarkers:NO];
    bandRenderableSeries.xAxisId = @"X1";
    bandRenderableSeries.yAxisId = @"Y1";
    
    [bandRenderableSeries setDataSeries:self.dataSeries[@"McadBandData"]];
    
    return bandRenderableSeries;
}

- (SCIRenderableSeriesBase*)generateColumnSeries {
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]];
    columnRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColor:[UIColor whiteColor] withThickness:1.f];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"X1";
    columnRenderableSeries.yAxisId = @"Y1";
    [columnRenderableSeries setDataSeries:self.dataSeries[@"McadColumnData"]];
    return columnRenderableSeries;
}

- (SCIRenderableSeriesBase*)generateColumnSeries1 {
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]];
    columnRenderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColor:[UIColor whiteColor] withThickness:1.f];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"X1";
    columnRenderableSeries.yAxisId = @"Y1";
    [columnRenderableSeries setDataSeries:self.dataSeries[@"VolumeData"]];
    return columnRenderableSeries;
}

- (void)generateDataSeries {
    
    self.dataSeries = [NSMutableDictionary new];
    
    SCIOhlcDataSeries * priceDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                             YType:SCIDataType_Double
                                                                        SeriesType:SCITypeOfDataSeries_XCategory];
    
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                          YType:SCIDataType_Double
                                                                     SeriesType:SCITypeOfDataSeries_XCategory];
    columnDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIXyDataSeries * rsiDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                       YType:SCIDataType_Double
                                                                  SeriesType:SCITypeOfDataSeries_XCategory];
    rsiDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIXyDataSeries * columnMcadDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                              YType:SCIDataType_Double
                                                                         SeriesType:SCITypeOfDataSeries_XCategory];
    columnMcadDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIXyyDataSeries * bandMcadDataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                              YType:SCIDataType_Double
                                                                         SeriesType:SCITypeOfDataSeries_XCategory];
    bandMcadDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIXyDataSeries * highDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                        YType:SCIDataType_Double
                                                                   SeriesType:SCITypeOfDataSeries_XCategory];
    highDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIXyDataSeries * lowDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                       YType:SCIDataType_Double
                                                                  SeriesType:SCITypeOfDataSeries_XCategory];
    
    lowDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCDMovingAverage *averageGainRsi = [[SCDMovingAverage alloc] initWithLength:14];
    SCDMovingAverage *averageLossRsi = [[SCDMovingAverage alloc] initWithLength:14];
    
    SCDMovingAverage *averageSLow = [[SCDMovingAverage alloc] initWithLength:12];
    SCDMovingAverage *averageFast = [[SCDMovingAverage alloc] initWithLength:26];
    SCDMovingAverage *averageSignal = [[SCDMovingAverage alloc] initWithLength:9];
    
    SCDMovingAverage *averageLow = [[SCDMovingAverage alloc] initWithLength:50];
    SCDMovingAverage *averageHigh = [[SCDMovingAverage alloc] initWithLength:200];
    
    SCDMultiPaneItem *previous = nil;
    for (SCDMultiPaneItem *item in self.dataSource) {
        
        
        SCIGenericType date = SCIGeneric(item.dateTime);
        SCIGenericType open = SCIGeneric(item.open);
        SCIGenericType high = SCIGeneric(item.high);
        SCIGenericType low = SCIGeneric(item.low);
        SCIGenericType close = SCIGeneric(item.close);
        SCIGenericType volume = SCIGeneric(item.volume);
        
        
        [priceDataSeries appendX:date
                            Open:open
                            High:high
                             Low:low
                           Close:close];
        
        [columnDataSeries appendX:date Y:volume];
        
        
        
        double rsiValue = [self rsiForAverageGain:averageGainRsi
                                       andAveLoss:averageLossRsi
                                         previous:previous
                                      currentItem:item];
        
        SCIGenericType rsi = SCIGeneric(rsiValue);
        [rsiDataSeries appendX:date Y:rsi];
        
        SCDMcadPointItem *mcadPoint = [self mcadPointForSlow:averageSLow
                                                     forFast:averageFast
                                                   forSignal:averageSignal
                                               andCloseValue:item.close];
        
        if (isnan(mcadPoint.divergence)) {
            mcadPoint.divergence = 0.00000000;
        }
        
        [columnMcadDataSeries appendX:date Y:SCIGeneric(mcadPoint.divergence)];
        [bandMcadDataSeries appendX:date Y1:SCIGeneric(mcadPoint.mcad) Y2:SCIGeneric(mcadPoint.signal)];
        
        [highDataSeries appendX:date Y:SCIGeneric([averageHigh push:item.close].current)];
        [lowDataSeries appendX:date Y:SCIGeneric([averageLow push:item.close].current)];
        
        previous = item;
        
    }
    
    
    self.dataSeries[@"CandleData"] = priceDataSeries;
    self.dataSeries[@"VolumeData"] = columnDataSeries;
    self.dataSeries[@"RsiData"] = rsiDataSeries;
    self.dataSeries[@"McadColumnData"] = columnMcadDataSeries;
    self.dataSeries[@"McadBandData"] = bandMcadDataSeries;
    self.dataSeries[@"HighData"] = highDataSeries;
    self.dataSeries[@"LowData"] = lowDataSeries;
    
}

- (double)rsiForAverageGain:(SCDMovingAverage*)averageGain
                 andAveLoss:(SCDMovingAverage*)averageLoss
                   previous:(SCDMultiPaneItem*)previous
                currentItem:(SCDMultiPaneItem*)item {
    
    double gain = item.close > previous.close ? item.close - previous.close : 0.0;
    double loss = previous.close > item.close ? previous.close - item.close : 0.0;
    
    [averageGain push:gain];
    [averageLoss push:loss];
    
    double relativeStrength = isnan(averageGain.current) || isnan(averageLoss.current) ? NAN : averageGain.current/averageLoss.current;
    
    return isnan(relativeStrength) ? NAN : 100.0 - (100.0/(1.0 + relativeStrength));
    
}

- (SCDMcadPointItem*)mcadPointForSlow:(SCDMovingAverage*)slow
                              forFast:(SCDMovingAverage*)fast
                            forSignal:(SCDMovingAverage*)signal
                        andCloseValue:(double)close {
    [slow push:close];
    [fast push:close];
    
    double macd = slow.current - fast.current;
    
    double signalLine = isnan(macd) ? NAN : [signal push:macd].current;
    double divergence = isnan(macd) || isnan(signalLine) ? NAN : macd - signalLine;
    
    SCDMcadPointItem *point = [SCDMcadPointItem new];
    point.mcad = macd;
    point.signal = signalLine;
    point.divergence = divergence;
    
    return point;
}

@end
