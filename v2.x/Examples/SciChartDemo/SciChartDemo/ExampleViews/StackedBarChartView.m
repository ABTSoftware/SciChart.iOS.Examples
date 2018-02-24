//
//  StackedBarChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 9/24/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedBarChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedBarChartView

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
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Bottom;
    yAxis.flipCoordinates = YES;
    
    double yValues1[] = {0.0, 0.1, 0.2, 0.4, 0.8, 1.1, 1.5, 2.4, 4.6, 8.1, 11.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 5.4, 6.4, 7.1, 8.0, 9.0};
    double yValues2[] = {2.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 0.1, 1.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 0.4, 10.1, 0.0, 0.0};
    double yValues3[] = {20.0, 4.1, 4.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 5.1, 5.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 10.4, 8.1, 10.0, 15.0};
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Data 1";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Data 2";
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds3.seriesName = @"Data 3";
    
    int size = sizeof(yValues1) / sizeof(yValues1[0]);
    for (int i = 0; i < size; i++) {
        double xValue = (double)i;
        [ds1 appendX:SCIGeneric(xValue) Y:SCIGeneric(yValues1[i])];
        [ds2 appendX:SCIGeneric(xValue) Y:SCIGeneric(yValues2[i])];
        [ds3 appendX:SCIGeneric(xValue) Y:SCIGeneric(yValues3[i])];
    }
    
    SCIVerticallyStackedColumnsCollection * columnCollection = [SCIVerticallyStackedColumnsCollection new];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds1 startColor:0xff567893 endColor:0xff3D5568]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds2 startColor:0xffACBCCA endColor:0xff439AAF]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds3 startColor:0xffDBE0E1 endColor:0xffB6C1C3]];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [columnCollection addAnimation:animation];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:columnCollection];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCICursorModifier new]]];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries startColor:(uint)startColor endColor:(uint)endColor {
    SCIStackedColumnRenderableSeries * renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.dataSeries = dataSeries;
    renderableSeries.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:startColor finish:endColor direction:SCILinearGradientDirection_Horizontal];
    renderableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor blackColor] withThickness:0.5];

    return renderableSeries;
}

@end
