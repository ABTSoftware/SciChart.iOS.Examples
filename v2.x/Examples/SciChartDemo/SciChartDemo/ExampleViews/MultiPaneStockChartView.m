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

@property (nonatomic, strong) SCIChartSurface * surface1;
@property (nonatomic, strong) SCIChartSurface * surface2;
@property (nonatomic, strong) SCIChartSurface * surface3;
@property (nonatomic, strong) SCIChartSurface * surface4;
@property (nonatomic) NSArray <SCDMultiPaneItem*> *dataSource;
@property NSMutableDictionary *dataSeries;

@property SCIAxisRangeSynchronization *rangeSync;
@property SCIAxisAreaSizeSynchronization *axisAreaSizeSync;

@end

@implementation MultiPaneStockChartView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _rangeSync = [SCIAxisRangeSynchronization new];
        _axisAreaSizeSync = [SCIAxisAreaSizeSynchronization new];
        _axisAreaSizeSync.syncMode = SCIAxisSizeSync_Right;
        _dataSource = [DataManager loadPaneStockData];
        [self generateDataSeries];
        
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        _surface1 = view;
        [_surface1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_surface1];
        
        view = [[SCIChartSurface alloc]init];
        _surface2 = (SCIChartSurface*)view;
        [_surface2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_surface2];
        
        view = [[SCIChartSurface alloc]init];
        _surface3 = (SCIChartSurface*)view;
        [_surface3 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_surface3];
        
        view = [[SCIChartSurface alloc]init];
        _surface4 = (SCIChartSurface*)view;
        [_surface4 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_surface4];
        
        
        NSDictionary *layout = @{@"SciChart1":_surface1, @"SciChart2":_surface2, @"SciChart3":_surface3, @"SciChart4":_surface4};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart3]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart4]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart1]-(0)-[SciChart2(SciChart3)]-(0)-[SciChart3(SciChart2)]-(0)-[SciChart4(SciChart3)]-(0)-|"
                                                                     options:0
                                                                     metrics:0
                                                                       views:layout]];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_surface1
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
    [self setupSurface:_surface1 showXAxis:YES];
    [self setupSurface:_surface2 showXAxis:NO];
    [self setupSurface:_surface3 showXAxis:NO];
    [self setupSurface:_surface4 showXAxis:NO];
    
    [self generateLineSeries: _surface1];
    [self generateLineSeries1:_surface1];
    [self generateCandleStick:_surface1];
    [_surface1 invalidateElement];
    
    [self generateColumnSeries:_surface2];
    [self generateBandSeries:_surface2];
    [_surface2 invalidateElement];
    
    [self generateLineSeries2:_surface3];
    [_surface3 invalidateElement];
    
    [self generateColumnSeries1:_surface4];
    [_surface4 invalidateElement];
}

- (void)setupSurface:(SCIChartSurface*)surface showXAxis:(BOOL)showXAxis {
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
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
    x1Drag.clipModeX = SCIClipMode_None;
    
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
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    SCILegendCellStyle* itemStyle = [[SCILegendCellStyle alloc]init];
    itemStyle.seriesNameFont = [UIFont fontWithName:@"Helvetica" size:8];
    [itemStyle setSeriesNameTextColor:[UIColor whiteColor]];
    [legendModifier setShowCheckBoxes:NO];
    [legendModifier setStyleOfItemCell:itemStyle];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[x1Pinch, y1Pinch, x1Drag, y1Drag, pzm, zpm, [SCIZoomExtentsModifier new], legendModifier]];
    surface.chartModifiers = gm;
}

- (void)generateLineSeries:(SCIChartSurface*)surface {
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    priceRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFF33DD33] withThickness:1.0];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    SCIXyDataSeries *data = self.dataSeries[@"HighData"];
    
    [priceRenderableSeries setDataSeries:data];
    [[surface renderableSeries]add:priceRenderableSeries];
    
    [self addAxisMarkerAnnotation:surface Yid:@"Y1" ValueFormat:@"$%.2f" Value:[[data yColumn]valueAt: [data count]-1] Color:0xFF33DD33];
}

- (void)generateLineSeries1:(SCIChartSurface*)surface {
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    priceRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFFFF3333] withThickness:1.0];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    SCIXyDataSeries *data = self.dataSeries[@"LowData"];
    
    [priceRenderableSeries setDataSeries:data];
    [[surface renderableSeries]add:priceRenderableSeries];
    
    [self addAxisMarkerAnnotation:surface Yid:@"Y1" ValueFormat:@"$%.2f" Value:[[data yColumn]valueAt: [data count]-1] Color:0xFFFF3333];
}

- (void)generateCandleStick: (SCIChartSurface*)surface {
    SCIFastCandlestickRenderableSeries * priceRenderableSeries = [SCIFastCandlestickRenderableSeries new];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:self.dataSeries[@"CandleData"]];
    priceRenderableSeries.style.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xff52cc54] withThickness:1.0];
    priceRenderableSeries.style.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xa052cc54]];
    priceRenderableSeries.style.strokeDownStyle  = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xffe26565] withThickness:1.0];
    priceRenderableSeries.style.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xd0e26565]];
    [[surface renderableSeries]add:priceRenderableSeries];
}

- (void)generateLineSeries2: (SCIChartSurface*)surface {
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    priceRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFFC6E6FF] withThickness:1.0];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    SCIXyDataSeries *data = self.dataSeries[@"RsiData"];
    [priceRenderableSeries setDataSeries:data];
    [[surface renderableSeries]add:priceRenderableSeries];
    
    [self addAxisMarkerAnnotation:surface Yid:@"Y1" ValueFormat:@"%.2f" Value:[[data yColumn]valueAt: [data count]-1] Color:0xa052cc54];
}

- (void)generateBandSeries: (SCIChartSurface*)surface{
    SCIFastBandRenderableSeries * bandRenderableSeries = [[SCIFastBandRenderableSeries alloc] init];
    
    bandRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor clearColor]];
    bandRenderableSeries.style.strokeY1Style = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xffe26565] withThickness:1.0];
    
    bandRenderableSeries.style.fillY1BrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor clearColor]];
    bandRenderableSeries.style.strokeY1Style = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xff52cc54] withThickness:1.0];
    
    bandRenderableSeries.pointMarker1 = nil;
    bandRenderableSeries.pointMarker = nil;
    bandRenderableSeries.xAxisId = @"X1";
    bandRenderableSeries.yAxisId = @"Y1";
    SCIXyyDataSeries *data = self.dataSeries[@"McadBandData"];
    
    [bandRenderableSeries setDataSeries: data];
    [[surface renderableSeries]add:bandRenderableSeries];
    
    [self addAxisMarkerAnnotation:surface Yid:@"Y1" ValueFormat:@"%.2f" Value:[[data y1Column]valueAt: [data count]-1] Color:0xa052cc54];
}

- (void)generateColumnSeries: (SCIChartSurface*)surface {
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]];
    columnRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor whiteColor] withThickness:1.f];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"X1";
    columnRenderableSeries.yAxisId = @"Y1";
    SCIXyDataSeries *data = self.dataSeries[@"McadColumnData"];
    
    [columnRenderableSeries setDataSeries:data];
    [[surface renderableSeries]add:columnRenderableSeries];
    
    [self addAxisMarkerAnnotation:surface Yid:@"Y1" ValueFormat:@"%.2f" Value:[[data yColumn]valueAt: [data count]-1] Color:0xa052cc54];
}

- (void)generateColumnSeries1 : (SCIChartSurface*)surface{
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]];
    columnRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor whiteColor] withThickness:1.f];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"X1";
    columnRenderableSeries.yAxisId = @"Y1";
    SCIXyDataSeries *data = self.dataSeries[@"VolumeData"];
    
    [columnRenderableSeries setDataSeries:data];
    [[surface renderableSeries]add:columnRenderableSeries];
    
    [self addAxisMarkerAnnotation:surface Yid:@"Y1" ValueFormat:@"%.2g" Value:[[data yColumn]valueAt: [data count]-1] Color:0xa052cc54];
}

-(void)addAxisMarkerAnnotation: (SCIChartSurface*)surface Yid:(NSString*)yID ValueFormat:(NSString*)format Value:(SCIGenericType)value Color:(uint)color{
    SCIAxisMarkerAnnotation *axisMarker = [[SCIAxisMarkerAnnotation alloc] init];
    [axisMarker setYAxisId: yID];
    [axisMarker.style setMargin: 5];
    
    SCITextFormattingStyle *textFormatting = [[SCITextFormattingStyle alloc]init];
    [textFormatting setColor: [UIColor whiteColor]];
    [textFormatting setFontSize: 12];
    
    [axisMarker.style setTextStyle: textFormatting];
    [axisMarker setFormattedValue: [NSString stringWithFormat: format, SCIGenericDouble(value)]];
    
    axisMarker.position = value;
    axisMarker.coordinateMode = SCIAnnotationCoordinate_Absolute;
    axisMarker.style.backgroundColor = [UIColor fromARGBColorCode:color];
    
    SCIAnnotationCollection *annCollection = surface.annotations;
    [annCollection add:axisMarker];
}

- (void)generateDataSeries {
    
    self.dataSeries = [NSMutableDictionary new];
    
    SCIOhlcDataSeries * priceDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                             YType:SCIDataType_Double
                                                                       ];
    [priceDataSeries setSeriesName:@"EUR/USD"];
    
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                          YType:SCIDataType_Double
                                                                    ];
    [columnDataSeries setSeriesName:@"Volume"];
    
    SCIXyDataSeries * rsiDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                       YType:SCIDataType_Double
                                                                 ];
    [rsiDataSeries setSeriesName:@"RSI"];
    
    SCIXyDataSeries * columnMcadDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                              YType:SCIDataType_Double
                                                                        ];
    [columnMcadDataSeries setSeriesName:@"Histogram"];
    
    SCIXyyDataSeries * bandMcadDataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                              YType:SCIDataType_Double
                                                                        ];
    [bandMcadDataSeries setSeriesName:@"MACD"];
    
    SCIXyDataSeries * highDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                        YType:SCIDataType_Double
                                                                  ];
    [highDataSeries setSeriesName:@"High Line"];
    
    SCIXyDataSeries * lowDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime
                                                                       YType:SCIDataType_Double
                                                                 ];
    [lowDataSeries setSeriesName:@"Low Line"];
    
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
