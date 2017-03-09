//
//  ThemeProviderUsingChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 12/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ThemeProviderUsingChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface ThemeProviderUsingChartView ()

@property (nonatomic) NSArray <SCDMultiPaneItem*> *dataSource;

@end

@implementation ThemeProviderUsingChartView
@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)initializeSurfaceRenderableSeries{

    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [priceDataSeries setSeriesName:@"Line Series"];
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setDrawPointMarkers: NO];
    [priceRenderableSeries setXAxisId: @"xAxis"];
    [priceRenderableSeries setYAxisId: @"yAxis"];
    [priceRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:priceRenderableSeries];
    
    
    SCIOhlcDataSeries * ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float
                                                                            YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [ohlcDataSeries setSeriesName:@"Candle Series"];
  
    ohlcDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];

    SCIFastCandlestickRenderableSeries * candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    candlestickRenderableSeries.xAxisId = @"xAxis";
    candlestickRenderableSeries.yAxisId = @"yAxis";
    [candlestickRenderableSeries setDataSeries: ohlcDataSeries];
    candlestickRenderableSeries.style.drawBorders = NO;
    [surface.renderableSeries add:candlestickRenderableSeries];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double
                                                                            YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [mountainDataSeries setSeriesName:@"Mountain Series"];
    mountainDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastMountainRenderableSeries * mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.xAxisId = @"xAxis";
    mountainRenderableSeries.yAxisId = @"yAxis";
    [mountainRenderableSeries setDataSeries: mountainDataSeries];

    [surface.renderableSeries add:mountainRenderableSeries];
    
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double
                                                                          YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [columnDataSeries setSeriesName:@"Column Series"];
    columnDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastColumnRenderableSeries * columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.style.dataPointWidth = 0.3;
    columnRenderableSeries.xAxisId = @"xAxis";
    columnRenderableSeries.yAxisId = @"yAxis";
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
        [mountainDataSeries appendX:date Y:SCIGeneric(item.close-1000)];
        [columnDataSeries appendX:date Y:SCIGeneric(item.close-3500)];
        i++;
        
    }
    
    [surface invalidateElement];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _dataSource = [DataManager loadThemeData];
        
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
        UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 45.f)];
        panel.backgroundColor = [UIColor blackColor];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:panel];
        
        UIButton *themeButton = [[UIButton alloc] initWithFrame:panel.frame];
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [themeButton setTitle:@"Chart V4 Dark" forState:UIControlStateNormal];
        [themeButton addTarget:self action:@selector(p_changeTheme:) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:themeButton];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(45)]-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)p_changeTheme:(UIButton*)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Theme"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *themes = @[@"Black Steel",
                        @"Bright Spark",
                        @"Chrome",
                        @"Chart V4 Dark",
                        @"Electric",
                        @"Expression Dark",
                        @"Expression Light",
                        @"Oscilloscope"];
    
    
    for (NSString *themeName in themes) {
        UIAlertAction *actionTheme = [UIAlertAction actionWithTitle:themeName
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self p_applyTheme:[themes indexOfObject:themeName]];
                                                                [button setTitle:themeName forState:UIControlStateNormal];
                                                            }];
        [alertController addAction:actionTheme];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alertController.popoverPresentationController.sourceView = self;
    alertController.popoverPresentationController.sourceRect = button.frame;
    [[self.window rootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)p_applyTheme:(SCIKeyTheme)themeKey {
    [surface applyThemeWithThemeProvider:[[SCIThemeProvider alloc] initWithThemeKey:themeKey]];
}

- (void)initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    [surface setChartTitle:@"Chart Title"];
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
    
    [self p_applyTheme:SCIChartV4DarkTheme];
    
}

- (void)addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisTitle:@"Right Axis Title"];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis2";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisTitle:@"Left Axis Title"];
    [axis setAxisAlignment:SCIAxisAlignment_Left];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisTitle:@"Bottom Axis Title"];
    [surface.xAxes add:axis];
    
}

- (void)addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
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
    
    SCILegendCollectionModifier *legend = [[SCILegendCollectionModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop
                                                                                 andOrientation:SCILegendOrientationVertical];
    legend.showCheckBoxes = NO;
    legend.styleOfItemCell = [SCILegendCellStyle new];
    legend.styleOfItemCell.seriesNameFont = [UIFont systemFontOfSize:10];
    legend.styleOfItemCell.cornerRadiusMarkerView = .0f;
    legend.styleOfItemCell.borderWidthMarkerView = .0f;
    legend.styleOfItemCell.seriesNameTextColor = [UIColor whiteColor];
    legend.styleOfItemCell.sizeMarkerView = CGSizeMake(30.f, 6.f);
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover, legend]];
    surface.chartModifier = gm;
}

@end

