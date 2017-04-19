//
//  SCIImpulseChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 9/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ImpulseChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ImpulseChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) initializeSurfaceRenderableSeries{
    
    SCIXyDataSeries * priceDataSeries = [DataManager getDampedSinewaveDataSeriesWithAmplitude:1.0
                                                                             andDampingfactor:0.05
                                                                                   pointCount:50
                                                                                         freq:5];
    
    priceDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setStrokeStyle:nil];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF0066FF]];
    [ellipsePointMarker setHeight:10];
    [ellipsePointMarker setWidth:10];
    
    SCIFastImpulseRenderableSeries * fourierRenderableSeries = [SCIFastImpulseRenderableSeries new];
    fourierRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0066FF withThickness:1.0];
    fourierRenderableSeries.style.pointMarker = ellipsePointMarker;
    [fourierRenderableSeries setDataSeries:priceDataSeries];
    [surface.renderableSeries add:fourierRenderableSeries];
    
    [surface invalidateElement];
}

-(instancetype)initWithFrame:(CGRect)frame{
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

-(void) setupSurface {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
}

@end
