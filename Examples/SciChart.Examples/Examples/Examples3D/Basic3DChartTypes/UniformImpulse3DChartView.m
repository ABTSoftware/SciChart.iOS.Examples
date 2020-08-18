//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UniformImpulse3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UniformImpulse3DChartView.h"

@implementation UniformImpulse3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.5];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIUniformGridDataSeries3D *ds = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:15 zSize:15];
    
    for (int i = 0; i < 15; ++i) {
        for (int j = 0; j < 15; ++j) {
            double y = sin(i * 0.25) / ((j+1) * 2);
            [ds updateYValue:@(y) atXIndex:i zIndex:j];
        }
    }
    
    SCISpherePointMarker3D *pointMarker = [SCISpherePointMarker3D new];
    pointMarker.fillColor = 0xFF1E90FF;
    pointMarker.size = 5.0;
    
    SCIImpulseRenderableSeries3D *rSeries = [SCIImpulseRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.stroke = 0xFF1E90FF;
    rSeries.strokeThickness = 2.0;
    rSeries.pointMarker = pointMarker;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
}

@end
