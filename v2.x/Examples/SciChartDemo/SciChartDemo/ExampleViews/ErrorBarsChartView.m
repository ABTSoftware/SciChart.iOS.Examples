//
//  ErrorBarsChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 9/17/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ErrorBarsChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ErrorBarsChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)initializeSurfaceRenderableSeries {
    
    int dataCount = 10;
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    //Getting Fourier dataSeries
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double x = time;
        double y = randf(-1.5, 1.5);
        [priceDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastFixedErrorBarsRenderableSeries *verticalRenderableSeries = [SCIFastFixedErrorBarsRenderableSeries new];
    verticalRenderableSeries.errorType = SCIErrorBarTypeRelative;
    verticalRenderableSeries.errorLow = 0.1;
    verticalRenderableSeries.errorHigh = 0.3;
    verticalRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f
                                                                                                green:130.f/255.f
                                                                                                 blue:180.f/255.f
                                                                                                alpha:1.f]
                                                                          withThickness:1.f];
    verticalRenderableSeries.xAxisId = @"xAxis";
    verticalRenderableSeries.yAxisId = @"yAxis";
    [verticalRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:verticalRenderableSeries];
    
    SCIFastFixedErrorBarsRenderableSeries *horizontalRenderableSeries = [SCIFastFixedErrorBarsRenderableSeries new];
    horizontalRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColor:[UIColor redColor] withThickness:1.f];
    horizontalRenderableSeries.errorDirection = SCIErrorBarDirectionHorizontal;
    horizontalRenderableSeries.errorDataPointWidth = 0.5f;
    horizontalRenderableSeries.xAxisId = @"xAxis";
    horizontalRenderableSeries.yAxisId = @"yAxis";
    horizontalRenderableSeries.errorMode = SCIErrorBarModeBoth;
    [horizontalRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:horizontalRenderableSeries];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setDrawBorder:YES];
    [ellipsePointMarker setFillBrush:[[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f
                                                                                          green:130.f/255.f
                                                                                           blue:180.f/255.f
                                                                                          alpha:1.f]]];
    [ellipsePointMarker setBorderPen:[[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:176.f/255.f
                                                                                        green:196.f/255.f
                                                                                         blue:222.f/255.f
                                                                                        alpha:1.f]
                                                                  withThickness:2.f]];
    [ellipsePointMarker setHeight:15];
    [ellipsePointMarker setWidth:15];
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    lineRenderableSeries.style.drawPointMarkers = YES;
    lineRenderableSeries.style.pointMarker = ellipsePointMarker;
    lineRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:176.f/255.f
                                                                                            green:196.f/255.f
                                                                                             blue:222.f/255.f
                                                                                            alpha:1.f]
                                                                      withThickness:1.f];
    lineRenderableSeries.xAxisId = @"xAxis";
    lineRenderableSeries.yAxisId = @"yAxis";
    [lineRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    
    [surface invalidateElement];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self setupSurface];
        [self addAxes];
        [self addModifiers];
        [self initializeSurfaceRenderableSeries];
    }
    
    return self;
}

- (void)setupSurface {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
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
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
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
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
}

@end
