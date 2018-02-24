//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "DashedLineChartView.h"
#import <SciChart/SciChart.h>

@implementation DashedLineChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
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
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    int dataCount = 20;
    SCIXyDataSeries * priceDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double y = arc4random_uniform(20);
        
        [priceDataSeries appendX:SCIGeneric(time) Y:SCIGeneric(y)];
    }
    
    dataCount = 1000;
    SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    for (int i = 0; i < dataCount; i++) {
        double time = 10 * i / (double)dataCount;
        double y = 2 * sin(time) + 10;
        
        [fourierDataSeries appendX:SCIGeneric(time) Y:SCIGeneric(y)];
    };
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFd6ffd7];
    ellipsePointMarker.height = 5;
    ellipsePointMarker.width = 5;
    
    SCIFastLineRenderableSeries * priceSeries = [SCIFastLineRenderableSeries new];
    priceSeries.pointMarker = ellipsePointMarker;
    priceSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFF99EE99] withThickness:1.f andStrokeDash:@[@(10.f), @(3.f), @(10.f), @(3.f)]];
    priceSeries.dataSeries = priceDataSeries;
    
    SCIFastLineRenderableSeries * fourierSeries = [SCIFastLineRenderableSeries new];
    fourierSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xFF4c8aff] withThickness:1.f andStrokeDash:@[@(50.f), @(14.f), @(50.f), @(14.f), @(50.f), @(14.f), @(50.f), @(14.f)]];
    fourierSeries.dataSeries = fourierDataSeries;

    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:priceSeries];
        [surface.renderableSeries add:fourierSeries];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [priceSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [fourierSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
