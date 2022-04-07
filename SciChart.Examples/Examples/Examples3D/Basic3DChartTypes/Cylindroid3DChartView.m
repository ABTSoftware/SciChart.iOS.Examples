//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Cylindroid3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "Cylindroid3DChartView.h"
#import "SCDRandomUtil.h"

@implementation Cylindroid3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-7 max:7];
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-7 max:7];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-7 max:7];
    
    const int sizeU = 40;
    const int sizeV = 20;
    SCICylindroidDataSeries3D *ds = [[SCICylindroidDataSeries3D alloc] initWithXZType:SCIDataType_Double yType:SCIDataType_Double uSize:sizeU vSize:sizeV];
    ds.a = @(3);
    ds.b = @(3);
    ds.h = @(7);
    
    for (int u = 0; u < sizeU; ++u) {
        for (int v = 0; v < sizeV; ++v) {
            double weight = 1.0 - ABS(2.0 * v / sizeV - 1);
            double offset = 1.0 - [SCDRandomUtil nextDouble];
            [ds setDisplacement:@(offset * weight) uIndex:u vIndex:v];
        }
    }

    unsigned int colors[7] = { 0xFF00008B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0};
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    
    SCIFreeSurfaceRenderableSeries3D *rSeries = [SCIFreeSurfaceRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.drawMeshAs = SCIDrawMeshAs_SolidWireframe;
    rSeries.stroke = 0x77228B22;
    rSeries.contourInterval = 0.1;
    rSeries.contourStroke = 0x77228B22;
    rSeries.strokeThickness = 2.0;
    rSeries.lightingFactor = 0.8;
    rSeries.meshColorPalette = palette;
    
    rSeries.paletteMinMaxMode = SCIFreeSurfacePaletteMinMaxMode_Relative;
    rSeries.paletteMinimum = [[SCIVector3 alloc] initWithX:3.0 y:0.0 z:0.0];
    rSeries.paletteMaximum = [[SCIVector3 alloc] initWithX:4.0 y:0.0 z:0.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
        
        [self.surface.worldDimensions assignX:200 y:200 z:200];
    }];    
}

@end
