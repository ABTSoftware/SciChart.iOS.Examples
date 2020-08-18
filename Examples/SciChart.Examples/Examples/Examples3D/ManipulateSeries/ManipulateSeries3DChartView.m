//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ManipulateSeries3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ManipulateSeries3DChartView.h"
#import "SCDButtonsTopPanel.h"
#import "SCDToolbarButton.h"
#import "SCDDataManager.h"
#import "SCDRandomUtil.h"
#import "SCDToolbarButtonsGroup.h"

static const int MAX_SERIES_AMOUNT = 15;
static const int DATA_POINTS_COUNT = 15;

@implementation ManipulateSeries3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (NSArray<SCDToolbarItem *> *)panelItems {
    __weak typeof(self) wSelf = self;
    return @[
        [[SCDToolbarButton alloc] initWithTitle:@"Add Series" image:nil andAction:^{ [wSelf add]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"Remove Series" image:nil andAction:^{ [wSelf remove]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"Clear" image:nil andAction:^{ [wSelf.surface.renderableSeries clear]; }],
    ];
}

#if TARGET_OS_OSX
- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    return @[[[SCDToolbarButtonsGroup alloc] initWithToolbarItems:self.panelItems]];
}
#elif TARGET_OS_IOS
- (SCIView *)providePanel {
    return [[SCDButtonsTopPanel alloc] initWithToolbarItems:self.panelItems];
}
#endif

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.autoRange = SCIAutoRange_Always;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    zAxis.autoRange = SCIAutoRange_Always;
    
    SCILegendModifier3D *legendModifier3D = [SCILegendModifier3D new];
    legendModifier3D.showSeriesMarkers = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
        [self.surface.chartModifiers add:legendModifier3D];
    }];
}

- (void)add {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        SCIRenderableSeries3DCollection *renderableSeries = self.surface.renderableSeries;
        if (renderableSeries.count >= MAX_SERIES_AMOUNT) return;
        
        SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
        SCIPointMetadataProvider3D *metadataProvider = [SCIPointMetadataProvider3D new];
        
        for (int i = 0; i < DATA_POINTS_COUNT; ++i) {
            double x = [SCDDataManager getGaussianRandomNumber:5 stdDev:1.5];
            double y = [SCDDataManager getGaussianRandomNumber:5 stdDev:1.5];
            double z = [SCDDataManager getGaussianRandomNumber:5 stdDev:1.5];
            [ds appendX:@(x) y:@(y) z:@(z)];
            
            SCIPointMetadata3D *metaData = [[SCIPointMetadata3D alloc] initWithVertexColor:[SCDDataManager randomColor] andScale:[SCDDataManager randomScale]];
            [metadataProvider.metadata addObject:metaData];
        }
        
        SCIScatterRenderableSeries3D *rSeries = [SCIScatterRenderableSeries3D new];
        rSeries.dataSeries = ds;
        rSeries.metadataProvider = metadataProvider;
        
        const int randValue = randi(0, 6);
        switch (randValue) {
            case 0:
                rSeries.pointMarker = [SCICubePointMarker3D new];
                break;
            case 1:
                rSeries.pointMarker = [SCIEllipsePointMarker3D new];
                break;
            case 2:
                rSeries.pointMarker = [SCIPyramidPointMarker3D new];
                break;
            case 3:
                rSeries.pointMarker = [SCIQuadPointMarker3D new];
                break;
            case 4:
                rSeries.pointMarker = [SCISpherePointMarker3D new];
                break;
            case 5:
                rSeries.pointMarker = [SCITrianglePointMarker3D new];
                break;
            default:
                break;
        }
        
        [renderableSeries add:rSeries];
        const NSInteger index = [renderableSeries indexOf:rSeries];
        ds.seriesName = [NSString stringWithFormat:@"Series %ld", index];
    }];
}

- (void)remove {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        SCIRenderableSeries3DCollection *renderableSeries = self.surface.renderableSeries;
        if (!renderableSeries.isEmpty) {
            [renderableSeries removeAt:0];
        }
    }];
}

@end
