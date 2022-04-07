//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMeshWithMetaDataProvider3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SurfaceMeshWithMetaDataProvider3DChartView.h"
#import "SCDDataManager.h"

#pragma mark - Surface Mesh Metadata Provider

@interface SurfaceMeshMetaDataProvider3D : SCIMetadataProvider3DBase<SCISurfaceMeshRenderableSeries3D *><ISCISurfaceMeshMetadataProvider3D>
- (instancetype)init;
@end
@implementation SurfaceMeshMetaDataProvider3D

- (instancetype)init {
    return [super initWithRenderableSeriesType:SCISurfaceMeshRenderableSeries3D.class];
}

- (void)updateMeshColors:(SCIUnsignedIntegerValues *)cellColors {
    SCISurfaceMeshRenderPassData3D *currentRenderPassData = (SCISurfaceMeshRenderPassData3D *)self.renderableSeries.currentRenderPassData;
    
    NSInteger countX = currentRenderPassData.countX - 1;
    NSInteger countZ = currentRenderPassData.countZ - 1;
    cellColors.count = currentRenderPassData.pointsCount;
    
    unsigned int *items = cellColors.itemsArray;
    for (int x = 0; x < countX; ++x) {
        for (int z = 0; z < countZ; ++z) {
            NSInteger index = x * countZ + z;
            unsigned int color;
            if  ((x >= 20 && x <= 26 && z > 0 && z < 47) || (z >= 20 && z <= 26 && x > 0 && x < 47)) {
                color = 0x00FFFFFF;
            } else {
                color = SCDDataManager.randomColor;
            }
            items[index] = color;
        }
    }
}

@end

#pragma mark - Chart Initialization

@implementation SurfaceMeshWithMetaDataProvider3DChartView {
    int _sizeX;
    int _sizeZ;
    NSTimeInterval _updateInterval;
    NSTimer *_timer;
    
    SCIUniformGridDataSeries3D *_ds0;
    SCIUniformGridDataSeries3D *_ds1;
}

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    _sizeX = 49;
    _sizeZ = 49;
    _updateInterval = 0.01;
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.drawMajorBands = NO;
    xAxis.drawLabels = NO;
    xAxis.drawMajorGridLines = NO;
    xAxis.drawMajorTicks = NO;
    xAxis.drawMinorGridLines = NO;
    xAxis.drawMinorTicks = NO;
    xAxis.planeBorderThickness = 0.0;

    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.drawMajorBands = NO;
    yAxis.drawLabels = NO;
    yAxis.drawMajorGridLines = NO;
    yAxis.drawMajorTicks = NO;
    yAxis.drawMinorGridLines = NO;
    yAxis.drawMinorTicks = NO;
    yAxis.planeBorderThickness = 0.0;
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    zAxis.drawMajorBands = NO;
    zAxis.drawLabels = NO;
    zAxis.drawMajorGridLines = NO;
    zAxis.drawMajorTicks = NO;
    zAxis.drawMinorGridLines = NO;
    zAxis.drawMinorTicks = NO;
    zAxis.planeBorderThickness = 0.0;
    
    _ds0 = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:_sizeX zSize:_sizeZ];
    _ds1 = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:_sizeX zSize:_sizeZ];
    
    for (int x = 48; x >= 24; --x) {
        double y = pow(x - 23.7, 0.3);
        double y2 = pow(49.5 - x, 0.3);
        
        [_ds0 updateYValue:@(y) atXIndex:x zIndex:24];
        [_ds1 updateYValue:@(y2 - 1.505) atXIndex:x zIndex:24];
    }
    
    for (int x = 24; x >= 0; x--) {
       for (int z = 49; z > 25; z--) {
           double y = pow(z - 23.7, 0.3);
           double y2 = pow(50.5 - z, 0.3) + 1.505;
           
           [_ds0 updateYValue:@(y) atXIndex:x + 24 zIndex:49 - z];
           [_ds0 updateYValue:@(y) atXIndex:z - 1 zIndex:24 - x];
           
           [_ds1 updateYValue:@(y2) atXIndex:x + 24 zIndex:49 - z];
           [_ds1 updateYValue:@(y2) atXIndex:z - 1 zIndex:24 - x];
           
           [_ds0 updateYValue:@(y) atXIndex:24 - x zIndex:49 - z];
           [_ds0 updateYValue:@(y) atXIndex:49 - z zIndex:24 - x];
           
           [_ds1 updateYValue:@(y2) atXIndex:24 - x zIndex:49 - z];
           [_ds1 updateYValue:@(y2) atXIndex:49 - z zIndex:24 - x];
           
           [_ds0 updateYValue:@(y) atXIndex:24 + x zIndex:z - 1];
           [_ds0 updateYValue:@(y) atXIndex:z - 1 zIndex:24 + x];
           
           [_ds1 updateYValue:@(y2) atXIndex:24 + x zIndex:z - 1];
           [_ds1 updateYValue:@(y2) atXIndex:z - 1 zIndex:x + 24];
           
           [_ds0 updateYValue:@(y) atXIndex:24 - x zIndex:z - 1];
           [_ds0 updateYValue:@(y) atXIndex:49 - z zIndex:24 + x];
           
           [_ds1 updateYValue:@(y2) atXIndex:24 - x zIndex:z - 1];
           [_ds1 updateYValue:@(y2) atXIndex:49 - z zIndex:x + 24];
       }
    }
    
    unsigned int colors[11] = { 0xFF00008B, 0xFF0000FF, 0xFF5F9EA0, 0xFF00FFFF, 0xFF32CD32, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF6347, 0xFFCD5C5C, 0xFFFF0000, 0xFF8B0000 };
    float stops[11] = { 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
    SCIGradientColorPalette *palette0 = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:11];
    SCIGradientColorPalette *palette1 = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:11];
    
    SCISurfaceMeshRenderableSeries3D *rSeries1 = [SCISurfaceMeshRenderableSeries3D new];
    rSeries1.dataSeries = _ds0;
    rSeries1.drawMeshAs = SCIDrawMeshAs_SolidMesh;
    rSeries1.drawSkirt = NO;
    rSeries1.meshColorPalette = palette0;
    rSeries1.metadataProvider = [SurfaceMeshMetaDataProvider3D new];
    
    SCISurfaceMeshRenderableSeries3D *rSeries2 = [SCISurfaceMeshRenderableSeries3D new];
    rSeries2.dataSeries = _ds1;
    rSeries2.drawMeshAs = SCIDrawMeshAs_SolidMesh;
    rSeries2.drawSkirt = NO;
    rSeries2.meshColorPalette = palette1;
    rSeries2.metadataProvider = [SurfaceMeshMetaDataProvider3D new];

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
    
    __weak typeof(self) wSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_updateInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [SCIUpdateSuspender usingWithSuspendable:wSelf.surface withBlock:^{
            [rSeries1 invalidateMetadata];
            [rSeries2 invalidateMetadata];
        }];
    }];
}

@end
