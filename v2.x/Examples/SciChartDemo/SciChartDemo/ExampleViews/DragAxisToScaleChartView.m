//
//  DragAxisToScaleChart.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "DragAxisToScaleChartView.h"
#import "DataManager.h"

@implementation DragAxisToScaleChartView
@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) createBandRenderableSeries{
    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager getFourierSeries:mountainDataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    [DataManager getDampedSinwave:1500 aplitude:3.0 phase:0.0 dampingFactor:0.005 count:5000 freq:10 dataSeries:lineDataSeries];
    
    SCIFastMountainRenderableSeries * mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    [mountainRenderableSeries setDataSeries:mountainDataSeries];
    [mountainRenderableSeries.style setAreaBrush:[[SCISolidBrushStyle alloc]initWithColorCode:0x771964FF]];
    [mountainRenderableSeries.style setBorderPen:[[SCISolidPenStyle alloc]initWithColorCode:0xFF0944CF withThickness:1.0]];
    [mountainRenderableSeries setYAxisId:@"leftAxisId"];
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    [lineRenderableSeries setDataSeries:lineDataSeries];
    [lineRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:2.0]];
    [lineRenderableSeries setYAxisId:@"rightAxisId"];
    
    [surface.renderableSeries add:mountainRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    
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
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [self createBandRenderableSeries];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(3) Max:SCIGeneric(6)]];
    [surface.xAxes add:axis];
    
    id<SCIAxis2DProtocol> rightYAxis = [[SCINumericAxis alloc] init];
    [rightYAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [rightYAxis setAxisId:@"rightAxisId"];
    [rightYAxis setAxisAlignment:SCIAxisAlignment_Right];
    [surface.yAxes add:rightYAxis];
    
    id<SCIAxis2DProtocol> leftYAxis = [[SCINumericAxis alloc] init];
    [leftYAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [leftYAxis setAxisId:@"leftAxisId"];
    [leftYAxis setAxisAlignment:SCIAxisAlignment_Left];
    [surface.yAxes add:leftYAxis];
    
    SCIXAxisDragModifier *xAxisDM = [[SCIXAxisDragModifier alloc]init];
    
    SCIYAxisDragModifier *leftYAxisDM = [[SCIYAxisDragModifier alloc]init];
    [leftYAxisDM setAxisId:@"leftAxisId"];
    [leftYAxisDM setDragMode:SCIAxisDragMode_Scale];
    
    SCIYAxisDragModifier *rightYAxisDM = [[SCIYAxisDragModifier alloc]init];
    [rightYAxisDM setAxisId:@"rightAxisId"];
    [rightYAxisDM setDragMode:SCIAxisDragMode_Scale];
    
    SCIZoomExtentsModifier *zem = [SCIZoomExtentsModifier new];
    
    surface.chartModifier = [[SCIModifierGroup alloc] initWithChildModifiers:@[xAxisDM, leftYAxisDM, rightYAxisDM, zem]];
    
    [surface invalidateElement];
}

@end
