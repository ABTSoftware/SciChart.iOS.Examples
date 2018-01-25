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

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
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
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [DataManager getFourierSeries:fourierDataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
    fourierRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    fourierRenderableSeries.dataSeries = fourierDataSeries;
    
    SCIDrawLineRenderableSeriesAnimation *animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [fourierRenderableSeries addAnimation:animation];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIRolloverModifier * rollover = [SCIRolloverModifier new];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], rollover]];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:fourierRenderableSeries];
        
        surface.chartModifiers = gm;
    }];
}

@end
