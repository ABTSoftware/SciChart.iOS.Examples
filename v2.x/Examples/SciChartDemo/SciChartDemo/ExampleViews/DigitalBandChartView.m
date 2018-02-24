//
//  BandChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "DigitalBandChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation DigitalBandChartView

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

- (void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    [xAxis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)]];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    DoubleSeries * data = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.01 PointCount:1000 Freq:10];
    DoubleSeries * moreData = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.05 PointCount:1000 Freq:12];
    
    SCIXyyDataSeries * dataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries appendRangeX:data.xValues Y1:data.yValues Y2:moreData.yValues Count:data.size];
    
    SCIFastBandRenderableSeries * rSeries = [SCIFastBandRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.isDigitalLine = YES;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x33279B27];
    rSeries.fillY1BrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FF1919];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    rSeries.strokeY1Style = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 withThickness:1.0];
    
    SCISweepRenderableSeriesAnimation * animation = [[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
    }];
}

@end
