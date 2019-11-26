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

    unsigned int fillColors[5] = { 0xFFFF0000, 0xFFFFA500, 0xFFFFFF00, 0xFFADFF2F, 0xFF006400 };
    float fillStops[5] = { 0.0, 0.25, 0.5, 0.75, 1.0 };
    SCIGradientColorPalette *fillColorPalette = [[SCIGradientColorPalette alloc] initWithColors:fillColors stops:fillStops count:5];

    unsigned int strokeColors[4] = { 0xFFDC143C, 0xFFFF8C00, 0xFF32CD32, 0xFF32CD32 };
    float strokeStops[4] = { 0.0, 0.3, 0.67, 1.0 };
    SCIGradientColorPalette *strokeColorPalette = [[SCIGradientColorPalette alloc] initWithColors:strokeColors stops:strokeStops count:4];
    
    SCIWaterfallRenderableSeries3D *rs = [SCIWaterfallRenderableSeries3D new];
    rs.dataSeries = ds;
    rs.stroke = 0xFF0000FF;
    rs.strokeThickness = 1.0;
    rs.sliceThickness = 0.0;
    rs.yColorMapping = fillColorPalette;
    rs.yStrokeColorMapping = strokeColorPalette;
    rs.metadataProvider = [[SCIDefaultSelectableMetadataProvider3D alloc] initWithSeriesType:SCIWaterfallRenderableSeries3D.class];
    rs.opacity = 0.8;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        self.surface.zAxis.autoRange = SCIAutoRange_Always;
        
        [self.surface.renderableSeries add:rs];
        [self.surface.chartModifiers addAll:ExampleViewBase.createDefault3DModifiers, [SCIVertexSelectionModifier3D new], nil];
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
}

@end
