    //
//  VerticalChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/5/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "VerticalChartView.h"
#import "DataManager.h"

@implementation VerticalChartView

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
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    xAxis.axisTitle = @"X-Axis";
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Top;
    yAxis.axisTitle = @"Y-Axis";
    
    SCIXyDataSeries * dataSeries0 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    DoubleSeries * doubleSeries = [[DoubleSeries alloc] initWithCapacity:20];
    [DataManager setRandomDoubleSeries:doubleSeries count:20];
    [dataSeries0 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    [doubleSeries clear];
    
    [DataManager setRandomDoubleSeries:doubleSeries count:20];
    [dataSeries1 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    SCIFastLineRenderableSeries * lineSeries0 = [SCIFastLineRenderableSeries new];
    lineSeries0.dataSeries = dataSeries0;
    lineSeries0.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF4682B4 withThickness:2.0];
    
    SCIFastLineRenderableSeries * lineSeries1 = [SCIFastLineRenderableSeries new];
    lineSeries1.dataSeries = dataSeries1;
    lineSeries1.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF00FF00 withThickness:2.0];
        
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:lineSeries0];
        [surface.renderableSeries add:lineSeries1];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [lineSeries0 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [lineSeries1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end

