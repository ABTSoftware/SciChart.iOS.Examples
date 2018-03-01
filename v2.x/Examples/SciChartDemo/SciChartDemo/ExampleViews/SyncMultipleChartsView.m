//
//  MultipleSurfaceView.m
//  SciChartDemo
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SyncMultipleChartsView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

static int const PointsCount = 500;

@implementation SyncMultipleChartsView {
    SCIMultiSurfaceModifier * _szem;
    SCIMultiSurfaceModifier * _spzm;
    SCIMultiSurfaceModifier * _sXDrag;
    SCIMultiSurfaceModifier * _sYDrag;
    SCIMultiSurfaceModifier * _sRollover;
    
    SCIAxisRangeSynchronization * _rSync;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _surface1 = [SCIChartSurface new];
        _surface1.translatesAutoresizingMaskIntoConstraints = NO;
        _surface2 = [SCIChartSurface new];
        _surface2.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_surface1];
        [self addSubview:_surface2];
        
        NSDictionary * layout = @{@"SciChart1":_surface1, @"SciChart2":_surface2};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart1]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart2]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart1(SciChart2)]-(0)-[SciChart2(SciChart1)]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    _rSync = [SCIAxisRangeSynchronization new];
    
    _szem = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomExtentsModifier class]];
    _spzm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIPinchZoomModifier class]];
    _sXDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIXAxisDragModifier class]];
    _sYDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIYAxisDragModifier class]];
    _sRollover = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIRolloverModifier class]];
    
    [self initChart:_surface1];
    [self initChart:_surface2];
}

- (void)initChart:(SCIChartSurface *)surface {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIFastLineRenderableSeries * rSeries = [self createRenderableSeries];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[_sXDrag, _sYDrag, _spzm, _szem, _sRollover]];
        
        [_rSync attachAxis:xAxis];
    }];
}

- (SCIFastLineRenderableSeries *)createRenderableSeries {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    for (int i = 0; i < PointsCount; i++) {
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(PointsCount * sin(i * M_PI * 0.1) / i)];
    }
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColor:[UIColor greenColor] withThickness:1.0];
    [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    
    return rSeries;
}

@end
