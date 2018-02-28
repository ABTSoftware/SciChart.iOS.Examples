//
//  ToolTipCustomization.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/26/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "UsingTooltipModifierChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation UsingTooltipModifierChartView

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
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries1.seriesName = @"Lissajous Curve";
    dataSeries1.acceptUnsortedData = YES;
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries2.seriesName = @"Sinewave";
    
    DoubleSeries * doubleSeries1 = [DataManager getLissajousCurveWithAlpha:0.8 beta:0.2 delta:0.43 count:500];
    DoubleSeries * doubleSeries2 = [DataManager getSinewaveWithAmplitude:1.5 Phase:1.0 PointCount:500];
    
    [self scaleValues:doubleSeries1.getXArray];
    [dataSeries1 appendRangeX:doubleSeries1.xValues Y:doubleSeries1.yValues Count:doubleSeries1.size];
    [dataSeries2 appendRangeX:doubleSeries2.xValues Y:doubleSeries2.yValues Count:doubleSeries2.size];
    
    SCIEllipsePointMarker * pointMarker1 = [SCIEllipsePointMarker new];
    pointMarker1.strokeStyle = nil;
    pointMarker1.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f green:130.f/255.f blue:180.f/255.f alpha:1.f]];
    pointMarker1.height = 5;
    pointMarker1.width = 5;
    
    SCIFastLineRenderableSeries * line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = dataSeries1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f green:130.f/255.f blue:180.f/255.f alpha:1.f] withThickness:0.5];
    line1.pointMarker = pointMarker1;
    
    SCIEllipsePointMarker * pointMarker2 = [SCIEllipsePointMarker new];
    pointMarker2.strokeStyle = nil;
    pointMarker2.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:255.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f]];
    pointMarker2.height = 5;
    pointMarker2.width = 5;
    
    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = dataSeries2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:255.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f] withThickness:0.5];
    line2.pointMarker = pointMarker2;
    
    SCITooltipModifier * toolTipModifier = [SCITooltipModifier new];
    toolTipModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:line1];
        [surface.renderableSeries add:line2];
        [surface.chartModifiers add:toolTipModifier];
        
        [line1 addAnimation:[[SCIFadeRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCIFadeRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (void)scaleValues:(SCIArrayController *)array {
    for (int i = 0; i < array.count; i++) {
        double value = SCIGenericDouble([array valueAt:i]);
        [array setValue:SCIGeneric((value + 1) * 5) At:i];
    }
}

@end
