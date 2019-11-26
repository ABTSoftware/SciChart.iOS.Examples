//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SelectScatterPoints3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SelectScatterPoints3DChartView.h"
#import "SCDDataManager.h"

@implementation SelectScatterPoints3DChartView

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    for (int i = 0; i < 250; ++i) {
        double x = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        double y = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        double z = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        
        [ds appendX:@(x) y:@(y) z:@(z)];
    }
    
    SCIEllipsePointMarker3D *pointMarker = [SCIEllipsePointMarker3D new];
    pointMarker.fillColor = 0xFF32CD32;
    pointMarker.size = 5.f;
    
    SCIScatterRenderableSeries3D *rs = [SCIScatterRenderableSeries3D new];
    rs.dataSeries = ds;
    rs.pointMarker = pointMarker;
    rs.metadataProvider = [[SCIDefaultSelectableMetadataProvider3D alloc] initWithRenderableSeriesType:SCIScatterRenderableSeries3D.class];
    
    SCIZoomExtentsModifier3D *zoomExtentsModifier = [SCIZoomExtentsModifier3D new];
    zoomExtentsModifier.executeOn = SCIExecuteOn_Fling;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs];
        [self.surface.chartModifiers add:[SCIPinchZoomModifier3D new]];
        [self.surface.chartModifiers add:[SCIVertexSelectionModifier3D new]];
        [self.surface.chartModifiers add:zoomExtentsModifier];
        [self.surface.chartModifiers add:[[SCIOrbitModifier3D alloc] initWithDefaultNumberOfTouches:2]];
    }];
}

@end
