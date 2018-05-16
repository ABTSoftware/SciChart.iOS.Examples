//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SyncMultipleChartsView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SyncMultipleChartsView.h"
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

- (void)initExample {
    _rSync = [SCIAxisRangeSynchronization new];
    
    _szem = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIZoomExtentsModifier class]];
    _spzm = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIPinchZoomModifier class]];
    _sXDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIXAxisDragModifier class]];
    _sYDrag = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIYAxisDragModifier class]];
    _sRollover = [[SCIMultiSurfaceModifier alloc] initWithModifierType:[SCIRolloverModifier class]];
    
    [self initChart:self.surface1];
    [self initChart:self.surface2];
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
