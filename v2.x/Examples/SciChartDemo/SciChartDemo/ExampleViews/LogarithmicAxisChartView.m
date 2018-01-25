//
//  LogarithmicAxisChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/5/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "LogarithmicAxisChartView.h"
#import "DataManager.h"

@implementation LogarithmicAxisChartView


@synthesize surface;

-(void) createBandRenderableSeries{
    SCIXyDataSeries *dataSeries1 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *dataSeries2 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries *dataSeries3 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    [DataManager getExponentialCurve:dataSeries1 cound:100 exponent:1.8];
    [DataManager getExponentialCurve:dataSeries2 cound:100 exponent:2.25];
    [DataManager getExponentialCurve:dataSeries3 cound:100 exponent:3.59];
    
    SCIFastLineRenderableSeries * lineSeries1 = [[SCIFastLineRenderableSeries alloc] init];
    [lineSeries1 setDataSeries:dataSeries1];
    [lineSeries1 setStrokeStyle:[[SCISolidPenStyle alloc]initWithColorCode:0xFFFFFF00 withThickness:1.5]];
    [lineSeries1.style setPointMarker:[self getPointMarkerWithSize:5 colorCode:0xFFFFFF00]];
    
    SCIDrawLineRenderableSeriesAnimation *animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [lineSeries1 addAnimation:animation];
    
    SCIFastLineRenderableSeries *lineSeries2 = [SCIFastLineRenderableSeries new];
    [lineSeries2 setDataSeries:dataSeries2];
    [lineSeries2 setStrokeStyle: [[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:1.5]];
    [lineSeries2.style setPointMarker:[self getPointMarkerWithSize:5 colorCode:0xFF279B27]];
    
    animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [lineSeries2 addAnimation:animation];
    
    SCIFastLineRenderableSeries *lineSeries3 = [SCIFastLineRenderableSeries new];
    [lineSeries3 setDataSeries:dataSeries3];
    [lineSeries3 setStrokeStyle: [[SCISolidPenStyle alloc]initWithColorCode:0xFFFF1919 withThickness:1.5]];
    [lineSeries3.style setPointMarker:[self getPointMarkerWithSize:5 colorCode:0xFFFF1919]];
    
    animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [lineSeries3 addAnimation:animation];
    
    [surface.renderableSeries add:lineSeries1];
    [surface.renderableSeries add:lineSeries2];
    [surface.renderableSeries add:lineSeries3];
    
    [surface invalidateElement];
}

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
    
    
    [self createBandRenderableSeries];
    
    id<SCIAxis2DProtocol> axis = [[SCILogarithmicNumericAxis alloc] init];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
    
    id<SCIAxis2DProtocol> yAxis = [[SCILogarithmicNumericAxis alloc] init];
    [yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:yAxis];
    
    [surface invalidateElement];
}

-(SCIEllipsePointMarker*) getPointMarkerWithSize: (int)size
                                       colorCode: (uint)colorCode{
    SCIEllipsePointMarker *ellipseMarker = [SCIEllipsePointMarker new];
    [ellipseMarker setWidth:size];
    [ellipseMarker setHeight:size];
    [ellipseMarker setStrokeStyle:[[SCISolidPenStyle alloc]initWithColorCode:colorCode withThickness:0.0]];
    [ellipseMarker setFillStyle:[[SCISolidBrushStyle alloc]initWithColorCode:colorCode]];
    
    return ellipseMarker;
}

@end
