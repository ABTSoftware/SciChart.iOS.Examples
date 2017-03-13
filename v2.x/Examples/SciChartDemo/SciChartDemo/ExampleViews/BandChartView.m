//
//  BandChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "BandChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation BandChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) createBandRenderableSeries{
    SCIXyDataSeries *xy1DataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries *xy2DataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [DataManager getDampedSinwave:0 aplitude:1.0 phase:0.0 dampingFactor:0.01 count:1000 freq:10 dataSeries:xy1DataSeries];
    [DataManager getDampedSinwave:0 aplitude:1.0 phase:0.0 dampingFactor:0.005 count:1000 freq:12 dataSeries:xy2DataSeries];
    
    SCIXyyDataSeries *xyyDataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [xyyDataSeries setY1Column:xy1DataSeries.yValues];
    [xyyDataSeries setY2Column:xy2DataSeries.yValues];
    [xyyDataSeries setXColumn:xy1DataSeries.xValues];
    
    SCIBandRenderableSeries * bandRenderableSeries = [[SCIBandRenderableSeries alloc] init];
    [bandRenderableSeries.style setBrush2:[[SCISolidBrushStyle alloc] initWithColorCode:0x50279b27]];
    [bandRenderableSeries.style setBrush1:[[SCISolidBrushStyle alloc] initWithColorCode:0x50ff1919]];
    [bandRenderableSeries.style setPen1:[[SCISolidPenStyle alloc] initWithColorCode:0xFFff1919 withThickness:1.0]];
    [bandRenderableSeries.style setPen2:[[SCISolidPenStyle alloc] initWithColorCode:0xFF279b27 withThickness:1.0]];
    [bandRenderableSeries setDataSeries:xyyDataSeries];
    
    [surface.renderableSeries add:bandRenderableSeries];
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
    [axis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)]];
    [surface.xAxes add:axis];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [yAxis setAutoRange:SCIAutoRange_Always];
    [surface.yAxes add:yAxis];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    [zpm setModifierName:@"ZoomPan Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    surface.chartModifier = gm;
    
    
    [surface invalidateElement];
}

@end
