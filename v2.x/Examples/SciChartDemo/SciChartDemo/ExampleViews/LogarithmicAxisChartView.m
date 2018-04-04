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

- (instancetype)initWithFrame:(CGRect)frame {
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

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCILogarithmicNumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCILogarithmicNumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries1.seriesName = @"Curve A";
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries2.seriesName = @"Curve B";
    SCIXyDataSeries * dataSeries3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries3.seriesName = @"Curve C";
    
    DoubleSeries * doubleSeries1 = [DataManager getExponentialCurveWithExponent:1.8 count:100];
    DoubleSeries * doubleSeries2 = [DataManager getExponentialCurveWithExponent:2.25 count:100];
    DoubleSeries * doubleSeries3 = [DataManager getExponentialCurveWithExponent:3.59 count:100];
    
    [dataSeries1 appendRangeX:doubleSeries1.xValues Y:doubleSeries1.yValues Count:doubleSeries1.size];
    [dataSeries2 appendRangeX:doubleSeries2.xValues Y:doubleSeries2.yValues Count:doubleSeries2.size];
    [dataSeries3 appendRangeX:doubleSeries3.xValues Y:doubleSeries3.yValues Count:doubleSeries3.size];

    uint line1Color = 0xFFFFFF00;
    uint line2Color = 0xFF279B27;
    uint line3Color = 0xFFFF1919;
    
    SCIFastLineRenderableSeries * line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = dataSeries1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line1Color withThickness:1.5];
    line1.pointMarker = [self getPointMarkerWithSize:5 colorCode:line1Color];

    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = dataSeries2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line2Color withThickness:1.5];
    line2.pointMarker = [self getPointMarkerWithSize:5 colorCode:line2Color];
    
    SCIFastLineRenderableSeries * line3 = [SCIFastLineRenderableSeries new];
    line3.dataSeries = dataSeries3;
    line3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:line3Color withThickness:1.5];
    line3.pointMarker = [self getPointMarkerWithSize:5 colorCode:line3Color];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:line1];
        [surface.renderableSeries add:line2];
        [surface.renderableSeries add:line3];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line3 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCIEllipsePointMarker *)getPointMarkerWithSize:(int)size colorCode:(uint)colorCode {
    SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
    pointMarker.height = size;
    pointMarker.width = size;
    pointMarker.strokeStyle = nil;
    pointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:colorCode];
    
    return pointMarker;
}

@end
