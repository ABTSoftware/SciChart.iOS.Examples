//
//  LinePerformanceView.m
//  SciChartDemo
//
//  Created by Admin on 28.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "LinePerformanceChartView.h"
#import <SciChart/SciChart.h>
#import "LinePerformanceControlPanelView.h"
#import "RandomUtil.h"

static inline double randf(double min, double max) {
    return [RandomUtil nextDouble] * (max - min) + min;
}

@implementation LinePerformanceChartView {
    NSMutableArray * _series;
}

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) clear {
    for (int i = 0; i < [_series count]; i++) {
        [surface.renderableSeries remove:_series[i]];
    }
    [_series removeAllObjects];
}

-(uint) randomColorCode {
    float red = randf(0, 1);
    float green = randf(0, 1);
    float blue = randf(0, 1);
    UIColor * color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return [color colorARGBCode];
}

-(void) createSeries100K {
    int dataCount = 100000;
    SCIFastLineRenderableSeries * rSeries = [self getRenderableSeriesWithDataCount:dataCount+1 Color:[self randomColorCode]];
    rSeries.xAxisId = @"xAxis";
    rSeries.yAxisId = @"yAxis";
    [_series addObject:rSeries];
    [surface.renderableSeries add:rSeries];
    
    [surface invalidateElement];
    [surface.viewportManager zoomExtents];
}

-(void) createSeries1KK {
    int dataCount = 1000000;
    SCIFastLineRenderableSeries * rSeries = [self getRenderableSeriesWithDataCount:dataCount+1 Color:[self randomColorCode]];
    rSeries.pixelAggregation = 10;
    rSeries.xAxisId = @"xAxis";
    rSeries.yAxisId = @"yAxis";
    [_series addObject:rSeries];
    [surface.renderableSeries add:rSeries];
    
    [surface invalidateElement];
    [surface.viewportManager zoomExtents];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        sciChartSurfaceView = [[SCIChartSurfaceView alloc]init];
        _series = [NSMutableArray new];
        
        __weak typeof(self) wSelf = self;
        
        LinePerformanceControlPanelView * panel = (LinePerformanceControlPanelView*)[[[NSBundle mainBundle] loadNibNamed:@"LinePerformanceControlPanelView" owner:self options:nil] firstObject];
        
        panel.onClearClicked = ^() { [wSelf clear]; };
        panel.onAdd100KClicked = ^() { [wSelf createSeries100K]; };
        panel.onAdd1KKClicked = ^() { [wSelf createSeries1KK]; };
        
        [self addSubview:panel];
        [self addSubview:sciChartSurfaceView];
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(SCIFastLineRenderableSeries *) getRenderableSeriesWithDataCount:(int)count Color:(unsigned int)color {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    SCIGenericType xData;
    xData.type = SCIDataType_Int32;
    SCIGenericType yData;
    yData.floatData = arc4random_uniform(100);
    yData.type = SCIDataType_Float;
    
    for (int i = 0; i < count; i++) {
        xData.int32Data = i;
        float value = yData.floatData + randf(-5.0, 5.0);
        yData.floatData = value;
        [dataSeries appendX:xData Y:yData];
    }
    
    SCIFastLineRenderableSeries * rSeries = [[SCIFastLineRenderableSeries alloc] init];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:0.5];
    
    rSeries.dataSeries = dataSeries;
    return rSeries;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"yAxis";
    [surface.yAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [surface.xAxes add:axis];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    [zpm setModifierName:@"PanZoom Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, zpm, pzm, zem]];
    surface.chartModifiers = gm;
    
    [surface invalidateElement];
}

@end
