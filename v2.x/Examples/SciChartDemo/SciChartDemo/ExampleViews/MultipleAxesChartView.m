//
//  MultipleAxesView.m
//  SciChartDemo
//
//  Created by Admin on 13.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "MultipleAxesChartView.h"
#import <SciChart/SciChart.h>

@implementation MultipleAxesChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) setupAxes {
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize: 16];
    [textFormatting setFontName: @"Helvetica"];
    [textFormatting setColorCode: 0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    // setup right Y axis
    {
        id<SCIAxis2DProtocol> yAxisRight = [[SCINumericAxis alloc] init];
        [yAxisRight setStyle: axisStyle];
        yAxisRight.axisId = @"Y1";
        [yAxisRight setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
        [yAxisRight setAxisTitle:@"Y1 Axis Title"];
        [surface.yAxes add:yAxisRight];
    }
    
    // setup bottom X axis
    {
        id<SCIAxis2DProtocol> xAxisBottom = [[SCINumericAxis alloc] init];
        xAxisBottom.axisId = @"X1";
        [xAxisBottom setStyle: axisStyle];
        [xAxisBottom setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
        
        UILabel *bottomAxisCustomTitleView = [UILabel new];
        bottomAxisCustomTitleView.font = [axisStyle axisTitleLabelStyle].getFont;
        bottomAxisCustomTitleView.textColor = [axisStyle axisTitleLabelStyle].color;
        bottomAxisCustomTitleView.text = @"X1 Custom View Title";
        bottomAxisCustomTitleView.backgroundColor = [UIColor lightGrayColor];
        bottomAxisCustomTitleView.translatesAutoresizingMaskIntoConstraints = NO;
        [bottomAxisCustomTitleView sizeToFit];
        
        [xAxisBottom setTitleCustomView:bottomAxisCustomTitleView];
        
        CGFloat height = bottomAxisCustomTitleView.frame.size.height;
        CGFloat width = bottomAxisCustomTitleView.frame.size.width;
        
        [bottomAxisCustomTitleView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[superView]-(<=1)-[titleView(%f)]", height]
                                                                                                    options:NSLayoutFormatAlignAllCenterX
                                                                                                    metrics:nil
                                                                                                      views:@{@"titleView" : bottomAxisCustomTitleView,
                                                                                                              @"superView" : bottomAxisCustomTitleView.superview}]];
        
        [bottomAxisCustomTitleView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[superView]-(<=1)-[titleView(%f)]", width]
                                                                                                    options:NSLayoutFormatAlignAllCenterY
                                                                                                    metrics:nil
                                                                                                      views:@{@"titleView" : bottomAxisCustomTitleView,
                                                                                                              @"superView" : bottomAxisCustomTitleView.superview}]];
        
        [surface.xAxes add:xAxisBottom];
    }

    // disable bands and grid lines for secondary axes if you do not need it
    [axisStyle setDrawMinorGridLines:NO];
    [axisStyle setDrawMajorGridLines:NO];
    [axisStyle setDrawMajorBands:NO];
    
    // setup left Y axis
    {
        id<SCIAxis2DProtocol> yAxisLeft = [[SCINumericAxis alloc] init];
        yAxisLeft.axisId = @"Y2";
        [yAxisLeft setStyle: axisStyle];
        [yAxisLeft setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
        [yAxisLeft setAxisTitle:@"Y2 Axis Title"];
        [yAxisLeft setAxisAlignment:SCIAxisAlignment_Left];
        [surface.yAxes add:yAxisLeft];
    }
    
    // setup top X axis
    {
        id<SCIAxis2DProtocol> xAxisTop = [[SCINumericAxis alloc] init];
        xAxisTop.axisId = @"X2";
        [xAxisTop setStyle: axisStyle];
        [xAxisTop setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
        [xAxisTop setAxisAlignment:SCIAxisAlignment_Top];
        
        UILabel *topAxisCustomTitleView = [UILabel new];
        topAxisCustomTitleView.font = [axisStyle axisTitleLabelStyle].getFont;
        topAxisCustomTitleView.textColor = [axisStyle axisTitleLabelStyle].color;
        topAxisCustomTitleView.text = @"X2 Custom View Title";
        topAxisCustomTitleView.backgroundColor = [UIColor lightGrayColor];
        topAxisCustomTitleView.translatesAutoresizingMaskIntoConstraints = NO;
        [topAxisCustomTitleView sizeToFit];
        
        [xAxisTop setTitleCustomView:topAxisCustomTitleView];
        
        CGFloat height = topAxisCustomTitleView.frame.size.height;
        CGFloat width = topAxisCustomTitleView.frame.size.width;
        
        [topAxisCustomTitleView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[superView]-(<=1)-[titleView(%f)]", height]
                                                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                                                 metrics:nil
                                                                                                   views:@{@"titleView" : topAxisCustomTitleView,
                                                                                                           @"superView" : topAxisCustomTitleView.superview}]];
        
        [topAxisCustomTitleView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[superView]-(<=1)-[titleView(%f)]", width]
                                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                                 metrics:nil
                                                                                                   views:@{@"titleView" : topAxisCustomTitleView,
                                                                                                           @"superView" : topAxisCustomTitleView.superview}]];
        [surface.xAxes add:xAxisTop];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    [self setupAxes];
    
    SCIAxisPinchZoomModifier * x1Pinch = [SCIAxisPinchZoomModifier new];
    x1Pinch.axisId = @"X1";
    SCIXAxisDragModifier * x1Drag = [SCIXAxisDragModifier new];
    x1Drag.axisId = @"X1";
    x1Drag.dragMode = SCIAxisDragMode_Scale;
    x1Drag.clipModeX = SCIZoomPanClipMode_None;
    SCIAxisPinchZoomModifier * x2Pinch = [SCIAxisPinchZoomModifier new];
    x2Pinch.axisId = @"X2";
    SCIXAxisDragModifier * x2Drag = [SCIXAxisDragModifier new];
    x2Drag.axisId = @"X2";
    x2Drag.dragMode = SCIAxisDragMode_Scale;
    x2Drag.clipModeX = SCIZoomPanClipMode_None;
    
    SCIAxisPinchZoomModifier * y1Pinch = [SCIAxisPinchZoomModifier new];
    y1Pinch.axisId = @"Y1";
    SCIYAxisDragModifier * y1Drag = [SCIYAxisDragModifier new];
    y1Drag.axisId = @"Y1";
    y1Drag.dragMode = SCIAxisDragMode_Pan;
    SCIAxisPinchZoomModifier * y2Pinch = [SCIAxisPinchZoomModifier new];
    y2Pinch.axisId = @"Y2";
    SCIYAxisDragModifier * y2Drag = [SCIYAxisDragModifier new];
    y2Drag.axisId = @"Y2";
    y2Drag.dragMode = SCIAxisDragMode_Pan;
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    [zpm setModifierName:@"PanZoom Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [y1Drag setModifierName:@"Y1 Drag Modifier"];
    [y2Drag setModifierName:@"Y2 Drag Modifier"];
    [x1Drag setModifierName:@"X1 Drag Modifier"];
    [x2Drag setModifierName:@"X2 Drag Modifier"];
    [y1Pinch setModifierName:@"Y1 Pinch Modifier"];
    [y2Pinch setModifierName:@"Y2 Pinch Modifier"];
    [x1Pinch setModifierName:@"X1 Pinch Modifier"];
    [x2Pinch setModifierName:@"X2 Pinch Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[x1Pinch, x2Pinch, y1Pinch, y2Pinch,
                                                                               x1Drag, x2Drag, y1Drag, y2Drag,
                                                                               pzm, zem, zpm]];
    surface.chartModifier = gm;
//    surface.style.leftAxisAreaSize = 5;
//    surface.style.topAxisAreaSize = 5;
//    surface.style.bottomAxisAreaSize = 100;
//    surface.style.rightAxisAreaSize = 100;
//    surface.style.autoSizeAxes = NO;
//    
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    int dataCount = 20;
    //Getting Fourier dataSeries
    for (int j = 0; j < dataCount; j++) {
        double time = 10 * j / (double)dataCount;
        double x = time;
        double y = arc4random_uniform(20);
        [priceDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    dataCount = 1000;
    //Getting Fourier dataSeries
    for (int j = 0; j < dataCount; j++) {
        double time = 10 * j / (double)dataCount;
        double x = time;
        double y = 2 * sin(x)+10;
        [fourierDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    fourierDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setDrawBorder:YES];
    [ellipsePointMarker setFillBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFd7ffd6]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    
    SCIFastLineRenderableSeries * priceRenderableSeries = [SCIFastLineRenderableSeries new];
    [priceRenderableSeries.style setPointMarker: ellipsePointMarker];
    [priceRenderableSeries.style setDrawPointMarkers: YES];
    [priceRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc] initWithColorCode:0xFF99EE99 withThickness:0.7]];
    [priceRenderableSeries setXAxisId: @"X1"];
    [priceRenderableSeries setYAxisId: @"Y1" ];
    [priceRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:priceRenderableSeries];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
    fourierRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFff8a4c withThickness:0.7];
    fourierRenderableSeries.xAxisId = @"X2";
    fourierRenderableSeries.yAxisId = @"Y2";
    [fourierRenderableSeries setDataSeries:fourierDataSeries];
    [surface.renderableSeries add:fourierRenderableSeries];
    
    [surface invalidateElement];
}

@end
