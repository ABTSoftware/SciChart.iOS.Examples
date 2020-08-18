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

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    const int xSize = 11;
    const int zSize = 4;
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.maxAutoTicks = 7;
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-4 max:4];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    
    SCIUniformGridDataSeries3D *ds = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:xSize zSize:zSize];
    ds.startX = @(0.0);
    ds.stepX = @(0.09);
    ds.startZ = @(0.0);
    ds.stepZ = @(0.75);
    
    double data[zSize][xSize] = {
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
    
    SCISurfaceMeshRenderableSeries3D *rSeries = [SCISurfaceMeshRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.heightScaleFactor = 0.0;
    rSeries.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rSeries.stroke = 0xFF228B22;
    rSeries.strokeThickness = 2.0;
    rSeries.maximum = 4;
    rSeries.meshColorPalette = palette0;
    rSeries.opacity = 0.7;
    
    SCISurfaceMeshRenderableSeries3D *rSeries1 = [SCISurfaceMeshRenderableSeries3D new];
    rSeries1.dataSeries = ds;
    rSeries1.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rSeries1.stroke = 0xFF228B22;
    rSeries1.strokeThickness = 2.0;
    rSeries1.maximum = 4;
    rSeries1.drawSkirt = NO;
    rSeries1.meshColorPalette = palette1;
    rSeries1.opacity = 0.9;
    
    SCISurfaceMeshRenderableSeries3D *rSeries2 = [SCISurfaceMeshRenderableSeries3D new];
    rSeries2.dataSeries = ds;
    rSeries2.heightScaleFactor = 0.0;
    rSeries2.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rSeries2.stroke = 0xFF228B22;
    rSeries2.strokeThickness = 2.0;
    rSeries2.maximum = 4;
    rSeries2.yOffset = 400;
    rSeries2.meshColorPalette = palette2;
    rSeries2.opacity = 0.7;

    SCIZoomExtentsModifier3D *zoomExtents = [SCIZoomExtentsModifier3D new];
    zoomExtents.resetPosition = [[SCIVector3 alloc] initWithX:-1300 y:1300 z:-1300];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.chartModifiers addAll:[SCIPinchZoomModifier3D new], [SCIOrbitModifier3D new], zoomExtents, nil];
        
        self.surface.camera = [SCICamera3D new];
        [self.surface.camera.position assignX:-1300 y:1300 z:-1300];
        [self.surface.worldDimensions assignX:1100 y:400 z:400];
    }];
}

@end
