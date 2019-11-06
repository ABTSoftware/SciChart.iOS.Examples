//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SimpleUniformMesh3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SimpleUniformMesh3DChartView.h"

@implementation SimpleUniformMesh3DChartView

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];;

    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];;
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.3];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIUniformGridDataSeries3D *ds = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:25 zSize:25];
    
    for (int x = 0; x < 25; ++x) {
        for (int z = 0; z < 25; ++z) {
            double xVal = 25 * x / 25;
            double zVal = 25 * z / 25;
            double yVal = sin(xVal * 0.2) / ((zVal + 1.0) * 2);
            [ds updateYValue:@(yVal) atXIndex:x zIndex:z];
        }
    }
   
    unsigned int colors[7] = { 0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0};
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    
    SCISurfaceMeshRenderableSeries3D *rs0 = [SCISurfaceMeshRenderableSeries3D new];
    rs0.dataSeries = ds;
    rs0.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rs0.stroke = 0x77228B22;
    rs0.strokeThickness = 2.0;
    rs0.drawSkirt = NO;
    rs0.meshColorPalette = palette;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs0];
        [self.surface.chartModifiers add:ExampleViewBase.createDefault3DModifiers];
    }];    
}

@end
