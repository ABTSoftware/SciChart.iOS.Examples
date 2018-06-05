//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VerticalChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "VerticalChartView.h"
#import "DataManager.h"

@implementation VerticalChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    xAxis.axisTitle = @"X-Axis";
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Top;
    yAxis.axisTitle = @"Y-Axis";
    
    SCIXyDataSeries * dataSeries0 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    DoubleSeries * doubleSeries = [[DoubleSeries alloc] initWithCapacity:20];
    [DataManager setRandomDoubleSeries:doubleSeries count:20];
    [dataSeries0 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    [doubleSeries clear];
    
    [DataManager setRandomDoubleSeries:doubleSeries count:20];
    [dataSeries1 appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    SCIFastLineRenderableSeries * lineSeries0 = [SCIFastLineRenderableSeries new];
    lineSeries0.dataSeries = dataSeries0;
    lineSeries0.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4682B4 withThickness:2.0];
    
    SCIFastLineRenderableSeries * lineSeries1 = [SCIFastLineRenderableSeries new];
    lineSeries1.dataSeries = dataSeries1;
    lineSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 withThickness:2.0];
        
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries0];
        [self.surface.renderableSeries add:lineSeries1];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [lineSeries0 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [lineSeries1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
