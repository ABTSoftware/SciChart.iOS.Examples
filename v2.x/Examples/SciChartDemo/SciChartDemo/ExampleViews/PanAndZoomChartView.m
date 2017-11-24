//
//  PanAndZoomChartView.m
//  SciChartDemo
//
//  Created by Admin on 23/03/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "PanAndZoomChartView.h"
#import <SciChart/SciChart.h>

@implementation PanAndZoomChartView


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(3) Max:SCIGeneric(6)]];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    zpm.clipModeX = SCIClipMode_StretchAtExtents;
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm]];
    surface.chartModifiers = gm;
    
    
    SCIPenStyle *pen1 = [[SCISolidPenStyle alloc] initWithColorCode:0xFF177B17 withThickness:1.0];
    SCIPenStyle *pen2 = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDD0909 withThickness:1.0];
    SCIPenStyle *pen3 = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0944CF withThickness:1.0];
    
    SCIBrushStyle *brush1 = [[SCISolidBrushStyle alloc] initWithColorCode:0x77279B27];
    SCIBrushStyle *brush2 = [[SCISolidBrushStyle alloc] initWithColorCode:0x77FF1919];
    SCIBrushStyle *brush3 = [[SCISolidBrushStyle alloc] initWithColorCode:0x771964FF];
    
    SCIFastMountainRenderableSeries * wave1 = [[SCIFastMountainRenderableSeries alloc] init];
    wave1.areaStyle = brush1;
    wave1.strokeStyle = pen1;
    wave1.dataSeries = [self getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.01 PointCount:1000 Frequency:10];
    [wave1 addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurveEaseOut]];
    
    SCIFastMountainRenderableSeries * wave2 = [[SCIFastMountainRenderableSeries alloc] init];
    wave2.areaStyle = brush2;
    wave2.strokeStyle = pen2;
    wave2.dataSeries = [self getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.024 PointCount:1000 Frequency:10];
    [wave2 addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurveEaseOut]];
    
    SCIFastMountainRenderableSeries * wave3 = [[SCIFastMountainRenderableSeries alloc] init];
    wave3.areaStyle = brush3;
    wave3.strokeStyle = pen3;
    wave3.dataSeries = [self getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.049 PointCount:1000 Frequency:10];
    [wave3 addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurveEaseOut]];
    
    [surface.renderableSeries add:wave1];
    [surface.renderableSeries add:wave2];
    [surface.renderableSeries add:wave3];
    
    [surface invalidateElement];
}

-(SCIXyDataSeries*) getDampedSinewaveWithPad:(int)pad Amplitude:(double)amplitude
                                      Phase:(double)phase DampingFactor:(double)dampingFactor
                                 PointCount:(int)pointCount Frequency:(int)freq
{
    SCIXyDataSeries * data = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    for (int i = 0; i < pad; i++) {
        double time = 10 * i / (double) pointCount;
        [data appendX:SCIGeneric(time) Y:SCIGeneric(0)];
    }
    
    for (int i = pad, j = 0; i < pointCount; i++, j++) {
        double time = 10 * i / (double) pointCount;
        double wn = 4 * M_PI_2 / (pointCount / (double) freq);
        
        double d = amplitude * sin(j * wn + phase);
        [data appendX:SCIGeneric(time) Y:SCIGeneric(d)];
        
        amplitude *= (1.0 - dampingFactor);
    }
    
    return data;
}

@end
