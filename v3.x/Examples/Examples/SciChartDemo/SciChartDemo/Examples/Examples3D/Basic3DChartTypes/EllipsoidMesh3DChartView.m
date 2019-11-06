//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// EllipsoidMesh3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "EllipsoidMesh3DChartView.h"
#import "SCDRandomUtil.h"

@implementation EllipsoidMesh3DChartView

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-7 max:7];;
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-7 max:7];;
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-7 max:7];;

    const int sizeU = 40;
    const int sizeV = 20;
    SCIEllipsoidDataSeries3D *ds = [[SCIEllipsoidDataSeries3D alloc] initWithDataType:SCIDataType_Double uSize:sizeU vSize:sizeV];
    ds.a = @(6);
    ds.b = @(6);
    ds.c = @(6);
    
    for (int u = 0; u < sizeU; ++u) {
        for (int v = 0; v < sizeV; ++v) {
            double weight = 1.0 - ABS(2. * v / sizeV - 1.0);
            double offset = [SCDRandomUtil nextDouble];
            [ds setDisplacement:@(offset * weight) uIndex:u vIndex:v];
        }
    }
    
    unsigned int colors[7] = { 0xFF00008B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0};
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    
    SCIFreeSurfaceRenderableSeries3D *rs0 = [SCIFreeSurfaceRenderableSeries3D new];
    rs0.dataSeries = ds;
    rs0.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rs0.stroke = 0x77228B22;
    rs0.contourInterval = 0.1;
    rs0.contourStroke = 0x77228B22;
    rs0.strokeThickness = 2.0;
    rs0.lightingFactor = 0.8;
    rs0.meshColorPalette = palette;
    
    rs0.paletteMinMaxMode = SCIFreeSurfacePaletteMinMaxMode_Relative;
    rs0.paletteMinimum = [[SCIVector3 alloc] initWithX:0.0 y:6.0 z:0.0];
    rs0.paletteMaximum = [[SCIVector3 alloc] initWithX:0.0 y:7.0 z:0.0];
    rs0.paletteAxialFactor =  [[SCIVector3 alloc] initWithX:0.0 y:0.0 z:0.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs0];
        [self.surface.chartModifiers add:ExampleViewBase.createDefault3DModifiers];

        [self.surface.worldDimensions assignX:200 y:200 z:200];
    }];
}

@end
