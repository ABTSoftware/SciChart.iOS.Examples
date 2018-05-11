//
//  SCIImpulseChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 9/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ImpulseChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ImpulseChartView

-(void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    DoubleSeries * ds1Points = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.05 PointCount:50 Freq:5];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries appendRangeX:ds1Points.xValues Y:ds1Points.yValues Count:ds1Points.size];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    ellipsePointMarker.strokeStyle = nil;
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF0066FF];
    ellipsePointMarker.height = 10;
    ellipsePointMarker.width = 10;
    
    SCIFastImpulseRenderableSeries * rSeries = [SCIFastImpulseRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0066FF withThickness:1.0];
    rSeries.pointMarker = ellipsePointMarker;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [rSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
