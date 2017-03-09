//
//  HeatmapChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 16.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "HeatmapChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation HeatmapChartView {
    SCIUniformHeatmapDataSeries * heatmapDataSeries;
    int size;
    int increment;
    NSTimer *timer;
    float scale;
    BOOL _running;
}

@synthesize sciChartSurfaceView;
@synthesize surface;

-(SCIFastUniformHeatmapRenderableSeries*) getHeatmapRenderableSeries{
    increment = 1;
    
    size = 100;
    SCIArrayController2D* values = [[SCIArrayController2D alloc]initWithType:SCIDataType_Double SizeX:size Y:size];
    
    for (int i=0; i<size; i++) {
        for (int j=0; j<size; j++) {
            [values setValue:SCIGeneric((double)i*j/10) AtX:i Y:j];
        }
    }
    
    heatmapDataSeries = [[SCIUniformHeatmapDataSeries alloc]initWithZValues:values StartX:SCIGeneric(0.0) StepX:SCIGeneric(0.1) StartY:SCIGeneric(0.0) StepY:SCIGeneric(0.1)];
    [heatmapDataSeries setSeriesName:@"Heatmap Series"];
    
    SCIFastUniformHeatmapRenderableSeries * heatmapRenderableSeries = [[SCIFastUniformHeatmapRenderableSeries alloc] init];
    [heatmapRenderableSeries.style setMax:SCIGeneric(1)];
    heatmapRenderableSeries.xAxisId = @"xAxis";
    heatmapRenderableSeries.yAxisId = @"yAxis";
    
    [heatmapRenderableSeries setDataSeries:heatmapDataSeries];
    return heatmapRenderableSeries;
}

-(void)updateHeatmapData:(NSTimer *)timer{
    float seriesPerPeriod = 30;
    float angle = (float)M_PI*scale/seriesPerPeriod;
    
    for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
            float v = (1 + sin(x * 0.04 + angle)) * 50 + (1 + sin(y * 0.1 + angle)) * 50 * (1 + sin(angle * 2));
            float r = sqrt(x * x + y * y);
            float exp = MAX(0, 1 - r * 0.008);
            float d= (v * exp + arc4random() % 2)/100;
            [heatmapDataSeries updateZAtXIndex:x yIndex:y withValue:SCIGeneric(d)];
        }
    }
    scale += 0.5;
    [surface invalidateElement];
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
        scale = 0.1;
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Arial"];
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
    [axis setFlipCoordinates:YES];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)]];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCITooltipModifier * tooltip = [[SCITooltipModifier alloc] init];
//    tooltip.style.tooltipSize = CGSizeMake(100, NAN);
    
    [tooltip setModifierName:@"ToolTip Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, tooltip]];
    surface.chartModifier = gm;
    
    [surface.renderableSeries add:[self getHeatmapRenderableSeries]];
    
    [surface invalidateElement];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    if(timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(updateHeatmapData:)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

@end
