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

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc] init];
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
    
    
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(3) Max:SCIGeneric(6)];

    id<SCIAxis2DProtocol> rightYAxis = [[SCINumericAxis alloc] init];
    rightYAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    rightYAxis.axisId = @"RightAxisId";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
    
    id<SCIAxis2DProtocol> leftYAxis = [[SCINumericAxis alloc] init];
    leftYAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    leftYAxis.axisId = @"LeftAxisId";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;
    
    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    [DataManager getFourierSeries:mountainDataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    DoubleSeries *dampedSinewave = [DataManager getDampedSinewaveWithPad:1500 Amplitude:3.0 Phase:0.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    [lineDataSeries appendRangeX:dampedSinewave.xValues Y:dampedSinewave.yValues Count:dampedSinewave.size];
    
    SCIFastMountainRenderableSeries *mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.dataSeries = mountainDataSeries;
    mountainRenderableSeries.areaStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x771964FF];
    mountainRenderableSeries.style.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF0944CF withThickness:2.0];
    mountainRenderableSeries.yAxisId = @"LeftAxisId";
    
    [mountainRenderableSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseInOut]];
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    lineRenderableSeries.dataSeries = lineDataSeries;
    lineRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:2.0];
    lineRenderableSeries.yAxisId = @"RightAxisId";
    
    [lineRenderableSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseInOut]];
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:leftYAxis];
    [surface.yAxes add:rightYAxis];
    [surface.renderableSeries add:mountainRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    
    SCIYAxisDragModifier *leftYAxisDM = [[SCIYAxisDragModifier alloc] init];
    leftYAxisDM.axisId = @"LeftAxisId";
    
    SCIYAxisDragModifier *rightYAxisDM = [[SCIYAxisDragModifier alloc] init];
    rightYAxisDM.axisId = @"RightAxisId";
    
    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[[SCIXAxisDragModifier alloc] init], leftYAxisDM, rightYAxisDM, [[SCIZoomExtentsModifier alloc] init]]];
    
    [surface invalidateElement];
}

@end
