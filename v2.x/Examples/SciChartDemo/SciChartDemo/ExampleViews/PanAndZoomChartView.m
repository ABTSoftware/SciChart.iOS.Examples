//
//  PanAndZoomChartView.m
//  SciChartDemo
//
//  Created by Admin on 23/03/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "PanAndZoomChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation PanAndZoomChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(3) Max:SCIGeneric(6)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    DoubleSeries * data1 = [DataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.01 PointCount:1000 Freq:10];
    DoubleSeries * data2 = [DataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.024 PointCount:1000 Freq:10];
    DoubleSeries * data3 = [DataManager getDampedSinewaveWithPad:300 Amplitude:1.0 Phase:0.0 DampingFactor:0.049 PointCount:1000 Freq:10];
    
    [ds1 appendRangeX:data1.xValues Y:data1.yValues Count:data1.size];
    [ds2 appendRangeX:data2.xValues Y:data2.yValues Count:data2.size];
    [ds3 appendRangeX:data3.xValues Y:data3.yValues Count:data3.size];
    
    SCIFastMountainRenderableSeries * rs1 = [self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77279B27 strokeColor:0xFF177B17];
    SCIFastMountainRenderableSeries * rs2 = [self getRenderableSeriesWithDataSeries:ds1 brushColor:0x77FF1919 strokeColor:0xFFDD0909];
    SCIFastMountainRenderableSeries * rs3 = [self getRenderableSeriesWithDataSeries:ds1 brushColor:0x771964FF strokeColor:0xFF0944CF];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rs1];
        [surface.renderableSeries add:rs2];
        [surface.renderableSeries add:rs3];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
}

- (SCIFastMountainRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries brushColor:(uint)brushColor strokeColor:(uint)strokeColor {
    SCIFastMountainRenderableSeries * rSeries = [SCIFastMountainRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:strokeColor withThickness:1.0];
    rSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:brushColor];
    rSeries.dataSeries = dataSeries;
    [rSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseOut]];
    
    return rSeries;
}

@end
