//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SimpleWaterfall3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SimpleWaterfall3DChartView.h"
#import "SCDRadix2FFT.h"
#import "SCDRandomUtil.h"

const int PointsPerSlice = 128;
const int SliceCount = 20;

@implementation SimpleWaterfall3DChartView {
    SCDRadix2FFT *_radixTransform;
}

- (void)initExample {
    _radixTransform = [[SCDRadix2FFT alloc] initWithSize:PointsPerSlice];
    
    SCIWaterfallDataSeries3D *ds = [[SCIWaterfallDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:PointsPerSlice zSize:SliceCount];
    ds.startX = @(10.0);
    ds.startZ = @(1.0);
    
    [self fill:ds];
    
    self.rSeries = [SCIWaterfallRenderableSeries3D new];
    self.rSeries.dataSeries = ds;
    [self setupColorPalettes];
    [self setupSliceThickness];
    [self setupPointMarker];
    
    self.rSeries.metadataProvider = [SCIDefaultSelectableMetadataProvider3D new];
    self.rSeries.opacity = 0.8;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        self.surface.zAxis.autoRange = SCIAutoRange_Always;
        
        [self.surface.renderableSeries add:self.rSeries];
        [self.surface.chartModifiers addAll:[SCDExampleBaseViewController createDefaultModifiers3D], [SCIVertexSelectionModifier3D new], nil];
    }];
}

- (void)fill:(SCIWaterfallDataSeries3D *)dataSeries {
    const int Count = PointsPerSlice * 2;
    
    double *re = new double[Count];
    double *im = new double[Count];

    for (int sliceIndex = 0; sliceIndex < SliceCount; ++sliceIndex) {
        for (int i = 0; i < Count; ++ i) {
            re[i] = 2.0 * sin(M_PI * i / 10.0) +
                    5.0 * sin(M_PI * i / 5.0) +
                    2.0 * randf(0.0, 1.0);
            im[i] = -10.0;
        }
        
        [_radixTransform runWithReals:re imaginaries:im];
        double scaleCoef = pow(1.5, sliceIndex * 0.3) / pow(1.5, SliceCount * 0.3);
        
        for (int pointIndex = 0; pointIndex < PointsPerSlice; ++pointIndex) {
            double reValue = re[pointIndex];
            double imValue = im[pointIndex];
            
            double mag = sqrt(reValue * reValue + imValue * imValue);
            double yVal = (randi(0, 10) + 10) * log10(mag / PointsPerSlice);
            
            yVal = (yVal < -25 || yVal > -5)
                ? (yVal < -25) ? -25.0 : (randi(0, 9) - 6)
                : yVal;
            
            [dataSeries updateYValue:@((-yVal * scaleCoef)) atXIndex:pointIndex zIndex:sliceIndex];
        }
    }
    
    delete[] re;
    delete[] im;
}

@end
