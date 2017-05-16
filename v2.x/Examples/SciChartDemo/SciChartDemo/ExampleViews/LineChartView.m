//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "LineChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation LineChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) initializeSurfaceRenderableSeries{
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [DataManager getFourierSeries:fourierDataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
    fourierRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    fourierRenderableSeries.dataSeries = fourierDataSeries;
    [surface.renderableSeries add:fourierRenderableSeries];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        sciChartSurfaceView = [[SCIChartSurfaceView alloc]initWithFrame:frame];
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
    
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)]];
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [SCIPinchZoomModifier new];
    SCIZoomExtentsModifier * zem = [SCIZoomExtentsModifier new];
    
    SCIRolloverModifier * rollover = [SCIRolloverModifier new];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifiers = gm;
}

@end
