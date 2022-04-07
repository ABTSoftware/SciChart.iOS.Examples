//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LogarithmicAxis3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "LogarithmicAxis3DChartView.h"
#import "SCDDataManager.h"

@implementation LogarithmicAxis3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCILogarithmicNumericAxis3D *xAxis = [SCILogarithmicNumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.drawMajorBands = NO;
    xAxis.textFormatting = @"#.#e+0";
    xAxis.scientificNotation = SCIScientificNotation_LogarithmicBase;
    
    SCILogarithmicNumericAxis3D *yAxis = [SCILogarithmicNumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.drawMajorBands = NO;
    yAxis.textFormatting = @"#.0";
    yAxis.scientificNotation = SCIScientificNotation_None;
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.5 max:0.5];
    
    const int count = 100;
    SCDDoubleSeries* data1 = [SCDDataManager getExponentialCurveWithExponent:1.8 count:count];
    
    SCIXyzDataSeries3D *ds1 = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    SCIPointMetadataProvider3D *metadataProvider = [SCIPointMetadataProvider3D new];
  
    for (int i = 0; i < count; ++i) {
        double x = [data1.xValues getValueAt:i];
        double y = [data1.yValues getValueAt:i];
        double z = [SCDDataManager getGaussianRandomNumber:15 stdDev:1.5];
        [ds1 appendX:@(x) y:@(y) z:@(z)];
        
        SCIPointMetadata3D *metaData = [[SCIPointMetadata3D alloc] initWithVertexColor:[SCDDataManager randomColor] andScale:[SCDDataManager randomScale]];
        [metadataProvider.metadata addObject:metaData];
    }
    
    SCISpherePointMarker3D *pointMarker = [SCISpherePointMarker3D new];
    pointMarker.size = 5.f;
    
    SCIPointLineRenderableSeries3D *rSeries = [SCIPointLineRenderableSeries3D new];
    rSeries.dataSeries = ds1;
    rSeries.strokeThickness = 2.0;
    rSeries.pointMarker = pointMarker;
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
