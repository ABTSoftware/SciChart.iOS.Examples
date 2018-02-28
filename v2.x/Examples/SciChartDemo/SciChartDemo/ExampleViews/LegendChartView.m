//
//  LegendChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/3/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "LegendChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import <Accelerate/Accelerate.h>

@implementation LegendChartView

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
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries1.seriesName = @"Curve A";
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries2.seriesName = @"Curve B";
    SCIXyDataSeries * dataSeries3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries3.seriesName = @"Curve C";
    SCIXyDataSeries * dataSeries4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries4.seriesName = @"Curve D";
    
    DoubleSeries * doubleSeries1 = [DataManager getStraightLinesWithGradient:4000 yIntercept:1.0 pointCount:10];
    DoubleSeries * doubleSeries2 = [DataManager getStraightLinesWithGradient:3000 yIntercept:1.0 pointCount:10];
    DoubleSeries * doubleSeries3 = [DataManager getStraightLinesWithGradient:2000 yIntercept:1.0 pointCount:10];
    DoubleSeries * doubleSeries4 = [DataManager getStraightLinesWithGradient:1000 yIntercept:1.0 pointCount:10];
    
    [dataSeries1 appendRangeX:doubleSeries1.xValues Y:doubleSeries1.yValues Count:doubleSeries1.size];
    [dataSeries2 appendRangeX:doubleSeries2.xValues Y:doubleSeries2.yValues Count:doubleSeries2.size];
    [dataSeries3 appendRangeX:doubleSeries3.xValues Y:doubleSeries3.yValues Count:doubleSeries3.size];
    [dataSeries4 appendRangeX:doubleSeries4.xValues Y:doubleSeries4.yValues Count:doubleSeries4.size];
    
    SCIFastLineRenderableSeries * line1 = [SCIFastLineRenderableSeries new];
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFF00 withThickness:1];
    line1.dataSeries = dataSeries1;
    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1];
    line2.dataSeries = dataSeries2;
    SCIFastLineRenderableSeries * line3 = [SCIFastLineRenderableSeries new];
    line3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 withThickness:1];
    line3.dataSeries = dataSeries3;
    SCIFastLineRenderableSeries * line4 = [SCIFastLineRenderableSeries new];
    line4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF1964FF withThickness:1];
    line4.dataSeries = dataSeries4;
    line4.isVisible = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:line1];
        [surface.renderableSeries add:line2];
        [surface.renderableSeries add:line3];
        [surface.renderableSeries add:line4];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line3 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line4 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        
        [surface.chartModifiers add:[[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop andOrientation:SCIOrientationVertical]];
    }];
}

@end
