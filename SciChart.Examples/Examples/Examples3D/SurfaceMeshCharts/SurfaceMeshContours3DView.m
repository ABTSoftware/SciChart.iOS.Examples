//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMeshContours3DView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SurfaceMeshContours3DView.h"

@implementation SurfaceMeshContours3DView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    const int w = 64;
    const int h = 64;
    const double ratio = 200.0 / 64.0;
    
    SCIUniformGridDataSeries3D *ds = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:w zSize:h];
    ds.stepX = @(0.01);
    ds.stepZ = @(0.01);
    
    for (int x = 0; x < w; x++) {
        for (int z = 0; z < h; z++) {
            double v = (1.0 + sin(x * 0.04 * ratio)) * 50 + (1.0 + sin(z * 0.1 * ratio)) * 50;
            double cx = w / 2.0;
            double cy = h / 2.0;
            double r = sqrt((x - cx) * (x - cx) + (z - cy) * (z - cy)) * ratio;
            double exp = MAX(0.0, 1.0 - r * 0.008);
            double zValue = v * exp;
            
            [ds updateYValue:@(zValue) atXIndex:x zIndex:z];
        }
    }
    
    unsigned int colors[11] = {0xFF00FFFF, 0xFF008000, 0xFF014421, 0xFFBDB76B, 0xFFDEB887, 0xFFE9967A, 0xFFADFF2F, 0xFFFF8C00, 0xFF8B4513, 0xFFA52A2A, 0xFFA52A2A };
    float stops[11] = { 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:11];
    
    SCISurfaceMeshRenderableSeries3D *rSeries = [SCISurfaceMeshRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.drawMeshAs = SCIDrawMeshAs_SolidWithContours;
    rSeries.stroke = 0x77228B22;
    rSeries.maximum = 150;
    rSeries.strokeThickness = 2.0;
    rSeries.drawSkirt = YES;
    rSeries.cellHardnessFactor = 1.0;
    rSeries.meshColorPalette = palette;
    rSeries.opacity = 0.8;

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];

        self.surface.camera = [SCICamera3D new];
        [self.surface.camera.position assignX:-1300 y:1300 z:-1300];
        [self.surface.worldDimensions assignX:600 y:300 z:300];
    }];
}

@end
