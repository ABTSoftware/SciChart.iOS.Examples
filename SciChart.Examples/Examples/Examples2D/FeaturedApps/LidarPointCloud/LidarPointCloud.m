//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LidarPointCloud.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "LidarPointCloud.h"
#import "SCDDataManager.h"

NSString *const SCDLIDARTQ38sw = @"tq3080_DSM_2M.asc";

@implementation LidarPointCloud

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCIColorMap *colorMap = [[SCIColorMap alloc] initWithColors:@[[SCIColor fromARGBColorCode:0xFF1E90FF], [SCIColor fromARGBColorCode:0xFF32CD32], SCIColor.orangeColor, SCIColor.redColor, SCIColor.purpleColor] andStops:@[@(0), @(0.2), @(0.5), @(0.7), @(1)]];
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.axisTitle = @"X Distance (metres)";
    xAxis.textFormatting = @"0m";
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.axisTitle = @"Y Distance (metres)";
    yAxis.textFormatting = @"0m";
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0 max:50];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.axisTitle = @"Height (metres)";
    zAxis.textFormatting = @"0m";

    SCDAscData *lidarData = [SCDDataManager ascDataFromFile:SCDLIDARTQ38sw];
    
    SCIScatterRenderableSeries3D *scatterSeries = [SCIScatterRenderableSeries3D new];
    scatterSeries.pointMarker = [SCIPixelPointMarker3D new];
    scatterSeries.dataSeries = [lidarData createXyzDataSeries];
    scatterSeries.metadataProvider = [lidarData createMetadataProviderWithColorMap:colorMap withinMin:0 andMax:50];
    
    unsigned int fillColors[5] = { 0xFF1E90FF, 0xFF32CD32, SCIColor.orangeColor.colorARGBCode, SCIColor.redColor.colorARGBCode, SCIColor.purpleColor.colorARGBCode };
    float fillStops[5] = { 0.0, 0.2, 0.5, 0.7, 1.0 };
    
    SCISurfaceMeshRenderableSeries3D *surfaceMeshSeries = [SCISurfaceMeshRenderableSeries3D new];
    surfaceMeshSeries.dataSeries = [lidarData createUniformGridDataSeries];
    surfaceMeshSeries.drawMeshAs = SCIDrawMeshAs_SolidWithContours;
    surfaceMeshSeries.meshColorPalette = [[SCIGradientColorPalette alloc] initWithColors:fillColors stops:fillStops count:5];
    surfaceMeshSeries.meshPaletteMode = SCIMeshPaletteMode_HeightMapInterpolated;
    surfaceMeshSeries.contourStroke = 0xFFF0FFFF;
    surfaceMeshSeries.contourStrokeThickness = 2;
    surfaceMeshSeries.minimum = 0;
    surfaceMeshSeries.maximum = 50;
    surfaceMeshSeries.opacity = 0.5;
    
    SCIZoomExtentsModifier3D *zoomExtentsModifier = [SCIZoomExtentsModifier3D new];
    zoomExtentsModifier.resetPosition = [[SCIVector3 alloc] initWithX:800 y:1000 z:800];
    zoomExtentsModifier.resetTarget = [[SCIVector3 alloc] initWithX:0 y:25 z:0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries addAll:scatterSeries, surfaceMeshSeries, nil];
        [self.surface.chartModifiers addAll:[SCIOrbitModifier3D new], zoomExtentsModifier, [SCIPinchZoomModifier3D new], nil];
        
        [self.surface.camera.position assignX:800 y:1000 z:800];
        [self.surface.worldDimensions assignX:1000 y:200 z:1000];
    }];
}

@end
