//
//  SplineScatterLineChart.m
//  SciChartDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "SplineScatterLineChart.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "SplineLineRenderableSeries.h"

@implementation SplineScatterLineChart

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.2) Max:SCIGeneric(0.2)];

    SCIXyDataSeries * originalData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    DoubleSeries * doubleSeries = [DataManager getSinewaveWithAmplitude:1.0 Phase:0.0 PointCount:28 Freq:7];
    [originalData appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.width = 7;
    ellipsePointMarker.height = 7;
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF006400 withThickness:1];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFFFFFFF];
    
    SplineLineRenderableSeries * splineRenderSeries = [SplineLineRenderableSeries new];
    splineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 withThickness:1.0];
    splineRenderSeries.dataSeries = originalData;
    splineRenderSeries.pointMarker = ellipsePointMarker;
    splineRenderSeries.upSampleFactor = 10;
    
    SCIFastLineRenderableSeries * lineRenderSeries = [SCIFastLineRenderableSeries new];
    lineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 withThickness:1.0];
    lineRenderSeries.dataSeries = originalData;
    lineRenderSeries.pointMarker = ellipsePointMarker;
  
    SCITextAnnotation * textAnnotation = [SCITextAnnotation new];
    textAnnotation.coordinateMode = SCIAnnotationCoordinate_Relative;
    textAnnotation.x1 = SCIGeneric(0.5);
    textAnnotation.y1 = SCIGeneric(0.01);
    textAnnotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    textAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    textAnnotation.style.textStyle.fontSize = 24;
    textAnnotation.text = @"Custom Spline Chart";
    textAnnotation.style.textColor = [UIColor whiteColor];
    textAnnotation.style.backgroundColor = [UIColor clearColor];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:splineRenderSeries];
        [surface.renderableSeries add:lineRenderSeries];
        [surface.annotations add:textAnnotation];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [splineRenderSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [lineRenderSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
