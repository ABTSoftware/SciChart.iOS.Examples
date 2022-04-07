//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SparseColumn3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SparseColumn3DChartView.h"
#import "SCDDataManager.h"

const int Count = 15;

@implementation SparseColumn3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    SCIPointMetadataProvider3D *metadataProvider = [SCIPointMetadataProvider3D new];
    
    for (int i = 0; i < Count; ++i) {
        for (int j = 0; j < Count; ++j) {
            if (i != j && (i % 3) == 0 && (j % 3) == 0) {
                double y = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
                [ds appendX:@(i) y:@(y) z:@(j)];
                
                SCIPointMetadata3D *metaData = [[SCIPointMetadata3D alloc] initWithVertexColor:SCDDataManager.randomColor];
                [metadataProvider.metadata addObject:metaData];
            }
        }
    }
    
    SCIColumnRenderableSeries3D *rSeries = [SCIColumnRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.metadataProvider = metadataProvider;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
}

@end
