//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import "DataManager.h"
#import "RandomUtil.h"

@implementation AddRemoveSeriesChartView

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    self.addSeries = ^{ [wSelf add]; };
    self.removeSeries = ^{ [wSelf remove]; };
    self.clearSeries = ^{ [wSelf clear]; };
}

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(150.0)];
    xAxis.axisTitle = @"X Axis";
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.axisTitle = @"Y Axis";
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    
    self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
}

- (void)add {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        DoubleSeries * randomDoubleSeries = [DataManager getRandomDoubleSeriesWithCount:150];
        SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
        [dataSeries appendRangeX:randomDoubleSeries.xValues Y:randomDoubleSeries.yValues Count:randomDoubleSeries.size];
    
        SCIFastMountainRenderableSeries * mountainRenderSeries = [[SCIFastMountainRenderableSeries alloc]init];
        mountainRenderSeries.dataSeries = dataSeries;
        mountainRenderSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0]];
        mountainRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0] withThickness:1.0];
        
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
