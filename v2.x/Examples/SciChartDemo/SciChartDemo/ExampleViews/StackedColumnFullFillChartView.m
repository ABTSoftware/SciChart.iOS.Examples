//
//  StackedColumnFullFillChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 11/9/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedColumnFullFillChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedColumnFullFillChartView

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
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    double porkData[] = {10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11};
    double vealData[] = {12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10};
    double tomatoesData[] = {7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22};
    double cucumberData[] = {16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17};
    double pepperData[] = {7, 24, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16};
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Pork Series";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Veal Series";
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds3.seriesName = @"Tomato Series";
    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds4.seriesName = @"Cucumber Series";
    SCIXyDataSeries * ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds5.seriesName = @"Pepper Series";
    
    int data = 1992;
    int size = sizeof(porkData) / sizeof(porkData[0]);
    for (int i = 0; i < size; i++) {
        double xValue = data + i;
        [ds1 appendX:SCIGeneric(xValue) Y:SCIGeneric(porkData[i])];
        [ds2 appendX:SCIGeneric(xValue) Y:SCIGeneric(vealData[i])];
        [ds3 appendX:SCIGeneric(xValue) Y:SCIGeneric(tomatoesData[i])];
        [ds4 appendX:SCIGeneric(xValue) Y:SCIGeneric(cucumberData[i])];
        [ds5 appendX:SCIGeneric(xValue) Y:SCIGeneric(pepperData[i])];
    }
    
    SCIVerticallyStackedColumnsCollection * columnCollection = [SCIVerticallyStackedColumnsCollection new];
    columnCollection.isOneHundredPercentSeries = YES;
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds1 FillColor:0xff226fb7]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds2 FillColor:0xffff9a2e]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds3 FillColor:0xffdc443f]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds4 FillColor:0xffaad34f]];
    [columnCollection add:[self getRenderableSeriesWithDataSeries:ds5 FillColor:0xff8562b4]];
    
    SCIWaveRenderableSeriesAnimation * animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [columnCollection addAnimation:animation];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;

    SCILegendModifier * legend = [[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop andOrientation:SCIOrientationVertical];

    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:columnCollection];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, legend, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIRolloverModifier new]]];
    }];
}

- (SCIStackedColumnRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries FillColor:(uint)fillColor {
    SCIStackedColumnRenderableSeries * renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.dataSeries = dataSeries;
    renderableSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:fillColor];
    renderableSeries.strokeStyle = nil;
    
    return renderableSeries;
}

@end
