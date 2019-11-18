//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomFreeSurface3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomFreeSurface3DChartView.h"

@implementation CustomFreeSurface3DChartView

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIUVFunc radialDistanceFunc = ^(double u, double v) { return 5.0 + sin(5.0 * (u + v)); };
    SCIUVFunc azimuthalAngleFunc = ^(double u, double v) { return u; };
    SCIUVFunc polarAngleFunc = ^(double u, double v) { return v; };
    SCIValueFunc xFunc = ^(double r, double theta, double phi) { return r * sin(theta) * cos(phi); };
    SCIValueFunc yFunc = ^(double r, double theta, double phi) { return r * cos(theta); };
    SCIValueFunc zFunc = ^(double r, double theta, double phi) { return r * sin(theta) * sin(phi); };
    
    SCICustomSurfaceDataSeries3D *ds = [[SCICustomSurfaceDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double uSize:30 vSize:30 radialDistanceFunc:radialDistanceFunc azimuthalAngleFunc:azimuthalAngleFunc polarAngleFunc:polarAngleFunc xFunc:xFunc yFunc:yFunc zFunc:zFunc];
    
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
    rs0.paletteMinimum = [[SCIVector3 alloc] initWithX:0.0 y:5.0 z:0.0];
    rs0.paletteMaximum = [[SCIVector3 alloc] initWithX:0.0 y:7.0 z:0.0];
    
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
