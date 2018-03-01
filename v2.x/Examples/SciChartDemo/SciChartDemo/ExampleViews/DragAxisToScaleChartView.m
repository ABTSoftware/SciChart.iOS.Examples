//
//  DragAxisToScaleChart.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "DragAxisToScaleChartView.h"
#import "DataManager.h"
#import "RandomWalkGenerator.h"

@implementation DragAxisToScaleChartView

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
    
    id<SCIAxis2DProtocol> rightYAxis = [SCINumericAxis new];
    rightYAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    rightYAxis.axisId = @"RightAxisId";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
    
    id<SCIAxis2DProtocol> leftYAxis = [SCINumericAxis new];
    leftYAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    leftYAxis.axisId = @"LeftAxisId";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;
    
    DoubleSeries * fourierSeries = [DataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 count:5000];
    DoubleSeries * dampedSinewave = [DataManager getDampedSinewaveWithPad:1500 Amplitude:3.0 Phase:0.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    [mountainDataSeries appendRangeX:fourierSeries.xValues Y:fourierSeries.yValues Count:fourierSeries.size];
    [lineDataSeries appendRangeX:dampedSinewave.xValues Y:dampedSinewave.yValues Count:dampedSinewave.size];
    
    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x771964FF];
    mountainSeries.style.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0944CF withThickness:2.0];
    mountainSeries.yAxisId = @"LeftAxisId";
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:2.0];
    lineSeries.yAxisId = @"RightAxisId";
    
    SCIYAxisDragModifier * leftYAxisDM = [SCIYAxisDragModifier new];
    leftYAxisDM.axisId = @"LeftAxisId";
    
    SCIYAxisDragModifier * rightYAxisDM = [SCIYAxisDragModifier new];
    rightYAxisDM.axisId = @"RightAxisId";
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:leftYAxis];
        [surface.yAxes add:rightYAxis];
        [surface.renderableSeries add:mountainSeries];
        [surface.renderableSeries add:lineSeries];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIXAxisDragModifier new], leftYAxisDM, rightYAxisDM, [SCIZoomExtentsModifier new]]];
        
        [mountainSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseInOut]];
        [lineSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3.0 curveAnimation:SCIAnimationCurve_EaseInOut]];
    }];
}

@end
