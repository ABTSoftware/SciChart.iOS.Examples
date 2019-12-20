//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddRemoveSeriesChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AddRemoveSeriesChartView.h"
#import "SCDDataManager.h"
#import "SCDRandomUtil.h"

@implementation AddRemoveSeriesChartView

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    self.addSeries = ^{ [wSelf add]; };
    self.removeSeries = ^{ [wSelf remove]; };
    self.clearSeries = ^{ [wSelf clear]; };
}

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:150.0];
    xAxis.axisTitle = @"X Axis";
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.axisTitle = @"Y Axis";
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    
    [self.surface.chartModifiers add:ExampleViewBase.createDefaultModifiers];
}

- (void)add {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        SCDDoubleSeries *randomDoubleSeries = [SCDDataManager getRandomDoubleSeriesWithCount:150];
        SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
        [dataSeries appendValuesX:randomDoubleSeries.xValues y:randomDoubleSeries.yValues];
    
        SCIFastMountainRenderableSeries *mountainRenderSeries = [[SCIFastMountainRenderableSeries alloc]init];
        mountainRenderSeries.dataSeries = dataSeries;
        mountainRenderSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0]];
        mountainRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0] thickness:1.0];
        
        [self.surface.renderableSeries add:mountainRenderSeries];
    }];
}

- (void)remove {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        if (self.surface.renderableSeries.count > 0) {
            [self.surface.renderableSeries removeAt:0];
        }
    }];
}

- (void)clear {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.renderableSeries clear];
    }];
}

@end
