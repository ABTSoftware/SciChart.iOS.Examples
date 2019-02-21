//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingPointMarkersChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingPointMarkersChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation UsingPointMarkersChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * ds5 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    int dataSize = 15;
    for(int i=0; i < dataSize; i++){
        [ds1 appendX:SCIGeneric(i) Y:SCIGeneric(randf(0.0, 1.0))];
        [ds2 appendX:SCIGeneric(i) Y:SCIGeneric(1 + randf(0.0, 1.0))];
        [ds3 appendX:SCIGeneric(i) Y:SCIGeneric(2.5 + randf(0.0, 1.0))];
        [ds4 appendX:SCIGeneric(i) Y:SCIGeneric(4 + randf(0.0, 1.0))];
        [ds5 appendX:SCIGeneric(i) Y:SCIGeneric(5.5 + randf(0.0, 1.0))];
    }
    
    [ds1 updateAt:7 Y:SCIGeneric(NAN)];
    [ds2 updateAt:7 Y:SCIGeneric(NAN)];
    [ds3 updateAt:7 Y:SCIGeneric(NAN)];
    [ds4 updateAt:7 Y:SCIGeneric(NAN)];
    [ds5 updateAt:7 Y:SCIGeneric(NAN)];
    
    SCIEllipsePointMarker * pointMarker1 = [SCIEllipsePointMarker new];
    pointMarker1.width = 15;
    pointMarker1.height = 15;
    pointMarker1.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x990077ff];
    pointMarker1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFADD8E6 withThickness:2.0];
    
    SCISquarePointMarker * pointMarker2 = [SCISquarePointMarker new];
    pointMarker2.width = 20;
    pointMarker2.height = 20;
    pointMarker2.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x99ff0000];
    pointMarker2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 withThickness:2.0];
    
    SCITrianglePointMarker * pointMarker3 = [SCITrianglePointMarker new];
    pointMarker3.width = 20;
    pointMarker3.height = 20;
    pointMarker3.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFFDD00];
    pointMarker3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF6600 withThickness:2.0];
    
    SCICrossPointMarker * pointMarker4 = [SCICrossPointMarker new];
    pointMarker4.width = 25;
    pointMarker4.height = 25;
    pointMarker4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF00FF withThickness:4.0];
    
    SCISpritePointMarker * pointMarker5 = [SCISpritePointMarker new];
    pointMarker5.width = 40;
    pointMarker5.height = 40;
    pointMarker5.textureBrush = [[SCITextureBrushStyle alloc] initWithImage:[UIImage imageNamed:@"Weather_Storm"]];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds1 pointMarker:pointMarker1 color:0xFFADD8E6]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds2 pointMarker:pointMarker2 color:0xFFFF0000]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds3 pointMarker:pointMarker3 color:0xFFFFFF00]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds4 pointMarker:pointMarker4 color:0xFFFF00FF]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithDataSeries:ds5 pointMarker:pointMarker5 color:0xFFF5DEB3]];
        
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
}

- (SCIFastLineRenderableSeries *)getRenderableSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries pointMarker:(id<SCIPointMarkerProtocol>)pointMarker color:(uint)color {
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:2.0];
    rSeries.pointMarker = pointMarker;
    rSeries.dataSeries = dataSeries;

    [rSeries addAnimation:[[SCIFadeRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
    
    return rSeries;
}

@end
