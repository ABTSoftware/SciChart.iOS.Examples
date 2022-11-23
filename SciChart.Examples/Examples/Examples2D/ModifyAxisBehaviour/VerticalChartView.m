//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDDataManager.h"

@implementation VerticalChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    xAxis.axisTitle = @"X-Axis";
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Top;
    yAxis.axisTitle = @"Y-Axis";
    
    SCIXyDataSeries *dataSeries0 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    SCDDoubleSeries *doubleSeries = [[SCDDoubleSeries alloc] initWithCapacity:20];
    [SCDDataManager setRandomDoubleSeries:doubleSeries count:20];
    [dataSeries0 appendValuesX:doubleSeries.xValues y:doubleSeries.yValues];
    
    [doubleSeries.xValues clear];
    [doubleSeries.yValues clear];
    
    [SCDDataManager setRandomDoubleSeries:doubleSeries count:20];
    [dataSeries1 appendValuesX:doubleSeries.xValues y:doubleSeries.yValues];
    
    SCIFastLineRenderableSeries *lineSeries0 = [SCIFastLineRenderableSeries new];
    lineSeries0.dataSeries = dataSeries0;
    lineSeries0.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF47bde6 thickness:2.0];
    
    SCIFastLineRenderableSeries *lineSeries1 = [SCIFastLineRenderableSeries new];
    lineSeries1.dataSeries = dataSeries1;
    lineSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:2.0];
        
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries0];
        [self.surface.renderableSeries add:lineSeries1];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations sweepSeries:lineSeries0 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:lineSeries1 duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
