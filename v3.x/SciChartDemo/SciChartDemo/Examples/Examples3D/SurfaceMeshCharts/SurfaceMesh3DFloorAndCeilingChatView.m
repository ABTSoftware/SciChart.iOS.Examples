//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMesh3DFloorAndCeilingChatView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SurfaceMesh3DFloorAndCeilingChatView.h"

@implementation SurfaceMesh3DFloorAndCeilingChatView

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.maxAutoTicks = 7;
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-4 max:4];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    
    const int xSize = 11;
    const int zSize = 4;
    SCIUniformGridDataSeries3D *ds = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:xSize zSize:zSize];
    ds.startX = @(0.0);
    ds.stepX = @(0.09);
    ds.startZ = @(0.0);
    ds.stepZ = @(0.75);
    
    double data[4][11] = {
        {-1.43, -2.95, -2.97, -1.81, -1.33, -1.53, -2.04, 2.08, 1.94, 1.42, 1.58},
        {1.77, 1.76, -1.1, -0.26, 0.72, 0.64, 3.26, 3.2, 3.1, 1.94, 1.54},
        {0, 0, 0, 0, 0, 3.7, 3.7, 3.7, 3.7, -0.48, -0.48},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    };
    
    for (int z = 0; z < zSize; z++) {
        for (int x = 0; x < xSize; x++) {
            NSLog(@"Setting value %f, for x: %d z: %d", data[z][x], x, z);
            [ds updateYValue:@(data[z][x]) atXIndex:x zIndex:z];
        }
    }
    
    unsigned int colors[7] = { 0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0.0, 0.1, 0.2, 0.4, 0.6, 0.8, 1.0 };
    
    SCIGradientColorPalette *palette0 = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    SCIGradientColorPalette *palette1 = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    SCIGradientColorPalette *palette2 = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    
    SCISurfaceMeshRenderableSeries3D *rs0 = [SCISurfaceMeshRenderableSeries3D new];
    rs0.dataSeries = ds;
    rs0.heightScaleFactor = 0.0;
    rs0.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rs0.stroke = 0xFF228B22;
    rs0.strokeThickness = 2.0;
    rs0.maximum = 4;
    rs0.meshColorPalette = palette0;
    rs0.opacity = 0.7;
    
    SCISurfaceMeshRenderableSeries3D *rs1 = [SCISurfaceMeshRenderableSeries3D new];
    rs1.dataSeries = ds;
    rs1.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rs1.stroke = 0xFF228B22;
    rs1.strokeThickness = 2.0;
    rs1.maximum = 4;
    rs1.drawSkirt = NO;
    rs1.meshColorPalette = palette1;
    rs1.opacity = 0.9;
    
    SCISurfaceMeshRenderableSeries3D *rs2 = [SCISurfaceMeshRenderableSeries3D new];
    rs2.dataSeries = ds;
    rs2.heightScaleFactor = 0.0;
    rs2.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rs2.stroke = 0xFF228B22;
    rs2.strokeThickness = 2.0;
    rs2.maximum = 4;
    rs2.yOffset = 400;
    rs2.meshColorPalette = palette2;
    rs2.opacity = 0.7;

    SCIZoomExtentsModifier3D *zoomExtents = [SCIZoomExtentsModifier3D new];
    zoomExtents.resetPosition = [[SCIVector3 alloc] initWithX:-1300 y:1300 z:-1300];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs0];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        [self.surface.chartModifiers addAll:[SCIPinchZoomModifier3D new], [SCIOrbitModifier3D new], zoomExtents, nil];
        
        self.surface.camera = [SCICamera3D new];
        [self.surface.camera.position assignX:-1300 y:1300 z:-1300];
        [self.surface.worldDimensions assignX:1100 y:400 z:400];
    }];
}

@end
