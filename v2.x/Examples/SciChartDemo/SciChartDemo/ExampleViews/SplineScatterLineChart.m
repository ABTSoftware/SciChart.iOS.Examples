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

-(void) initializeSurfaceRenderableSeries{
    SCIXyDataSeries * originalData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    DoubleSeries * doubleSeries = [DataManager getSinewaveWithAmplitude:1.0 Phase:0.0 PointCount:28 Freq:7];
    [originalData appendRangeX:[doubleSeries xValues] Y:[doubleSeries yValues] Count: [doubleSeries size]];
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.width = 7;
    ellipsePointMarker.height = 7;
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF006400 withThickness:1];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFFFFFFF];
    
    SplineLineRenderableSeries * splineRenderSeries = [SplineLineRenderableSeries new];
    splineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 withThickness:1.0];
    [splineRenderSeries setDataSeries:originalData];
    [splineRenderSeries setPointMarker:ellipsePointMarker];
    [splineRenderSeries setUpSampleFactor:10];
    
    SCIScaleRenderableSeriesAnimation *animation = [[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [splineRenderSeries addAnimation:animation];
    
    SCIFastLineRenderableSeries * lineRenderSeries = [SCIFastLineRenderableSeries new];
    lineRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4282B4 withThickness:1.0];
    [lineRenderSeries setDataSeries:originalData];
    [lineRenderSeries setPointMarker:ellipsePointMarker];
    
    animation = [[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [lineRenderSeries addAnimation:animation];
    
    [surface.renderableSeries add:splineRenderSeries];
    [surface.renderableSeries add:lineRenderSeries];
    
    SCITextFormattingStyle *textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:24];
    SCITextAnnotation * textAnnotation = [[SCITextAnnotation alloc] init];
    textAnnotation.coordinateMode = SCIAnnotationCoordinate_Relative;
    textAnnotation.x1 = SCIGeneric(0.5);
    textAnnotation.y1 = SCIGeneric(0.01);
    textAnnotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    textAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    textAnnotation.style.textStyle = textStyle;
    textAnnotation.text = @"Custom Spline Chart";
    textAnnotation.style.textColor = [UIColor whiteColor];
    textAnnotation.style.backgroundColor = [UIColor clearColor];
    
    surface.annotations = [[SCIAnnotationCollection alloc] initWithChildAnnotations:@[textAnnotation]];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
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

    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes {
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.2) Max:SCIGeneric(0.2)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm]];
    surface.chartModifiers = gm;
}

@end
